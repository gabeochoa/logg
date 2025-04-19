//
//  ContentView.swift
//  bookmarkd
//
//  Created by gabeochoa on 4/18/25.
//

import SwiftUI

public func closeButtonAction() {
    exit(0)
}

struct ContentView: View {
    @State private var activeBookPage: UUID? = nil
    @State private var searchSheetOpen: Bool = false

    var hasActiveBookPage: Bool {
        return activeBookPage != nil
    }

    var body: some View {
        TabView {
            VStack {
                SearchSheet(bookPage: $activeBookPage)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            .tag(0)
        }
        /*
        VStack {
            HStack {
                Button(action: {
                    activeBookPage = data.books[0].id
                }
                ) {
                    Text("Example Book Detail")
                }
                Button(action: {
                    searchSheetOpen = true
                }) {
                    Text("+")
                }
                .sheet(isPresented: $searchSheetOpen) {
                    SearchSheet(bookPage: $activeBookPage)
                        .frame(height: 300)
                }
                .sheet(
                    isPresented: Binding<Bool>(
                        get: { activeBookPage != nil },
                        set: { newValue in
                            if !newValue { activeBookPage = nil }
                        })
                ) {
                    if let bookID = activeBookPage {
                        BookDetailPage(
                            book: bookFromID(id: bookID)
                        )
                    }
                }
                Button(action: closeButtonAction) {
                    Text("Close")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        */
    }
}

#Preview {
    ContentView()
}
