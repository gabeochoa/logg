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

            VStack {
                SearchSheet(bookPage: $activeBookPage)
            }
            .tabItem {
                Image(systemName: "person.circle")
                    Text("Profile")
            }
            .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
