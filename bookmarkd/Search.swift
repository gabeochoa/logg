//
//  Search.swift
//  bookmarkd
//
//  Created by gabeochoa on 4/18/25.
//

import SwiftUI

struct SearchSheet: View {
    @Binding var bookPage: UUID?
    @State private var searchText: String = ""

    @Environment(\.dismiss) var dismiss

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return data.books
        } else {
            return data.books.filter { book in
                book.name.lowercased().contains(searchText.lowercased())
                    || book.author.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack{
            List {
                ForEach(filteredBooks, id: \.id) { 
                    book in
                    NavigationLink(value: book) {
                        SearchResult(book: book)
                    }
                }
            }
            .navigationDestination(for: Book.self) { 
                book in
                BookDetailPage(book: book)
            }
            .searchable(text: $searchText, placement: .automatic)
        }
    }
}

struct SearchResult: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(book.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    Text(String("(\(book.year))"))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.vertical, 10)
    }
}


#Preview {
    SearchSheet(bookPage: .constant(getBooks()[0].id))
}
