
import Cocoa
import SwiftUI

struct SearchSheet : View {
    @Binding var bookPage: UUID?
    @State private var searchText: String = ""

    @Environment(\.dismiss) var dismiss  

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return data.books
        } else {
            return data.books.filter { book in
                book.name.lowercased().contains(searchText.lowercased()) ||
                book.author.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack {
            List {
                ForEach(filteredBooks) { 
                    book in 
                    Button(action: { 
                        bookPage = book.id 
                        dismiss()
                    }) {
                        SearchResult(book: book)
                    }
                }
                .searchable(text: $searchText)
                .padding(10)
            }
            Button(action: closeButtonAction){
                Text("Close")
            }
        }
    }
}


struct SearchResult: View {
    var book: Book

    var body: some View {
        HStack {
            HStack {
                Text(book.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(String("(\(book.year))"))
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.leading, 10)
            .padding(.vertical, 8)

            Spacer()
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding([.leading, .trailing], 10)
    }
}
