

// Run any SwiftUI view as a Mac app.

import Cocoa
import SwiftUI

struct Book: Identifiable {
     let id = UUID()
     var author: String
     var name: String
     var year: Int = 2024
 }

struct User: Identifiable {
    let id = UUID()
    let name: String 
}

struct Review: Identifiable {
     let id:UUID = UUID()
     let book_id:UUID
     let user_id:UUID
     let content: String
}

private var books = getBooks()

private var users = [
    User(name: "choicehoney"),
    User(name: "bagelseed"),
]

private var reviews = [
    Review(book_id: books[0].id, user_id: users[0].id, content: "Review 1"),
    Review(book_id: books[0].id, user_id: users[1].id, content: "Review 2 🤷"),
]


public func closeButtonAction(){
    exit(0)
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

struct SearchSheet : View {
    @State private var searchText: String = ""

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { book in
                book.name.lowercased().contains(searchText.lowercased()) ||
                book.author.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack {
            List {
                ForEach(filteredBooks) { 
                    book in SearchResult(book: book)
                }
                .searchable(text: $searchText)
                .padding(10)
            }
            Button(action: closeButtonAction){
                Text("C")
            }
        }
    }
}

struct ContentView: View {
    @State private var searchSheetOpen: Bool = false
    var body: some View {
        VStack {
            HStack {
                Button(action: closeButtonAction){
                    Text("A")
                }
                Button(action: {
                    searchSheetOpen = true
                }){
                    Text("+")
                }
                .sheet(isPresented: $searchSheetOpen){
                    SearchSheet()
                    .frame(height:300)
                }
                Button(action: closeButtonAction){
                    Text("C")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

NSApplication.shared.run {
    ContentView()
}

extension NSApplication {
    public func run<V: View>(@ViewBuilder view: () -> V) {
        let appDelegate = AppDelegate(view())
        NSApp.setActivationPolicy(.regular)
        mainMenu = customMenu
        delegate = appDelegate
        run()
    }

    var customMenu: NSMenu {
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu()
        let appName = ProcessInfo.processInfo.processName
        appMenu.submenu?.addItem(NSMenuItem(title: "About \(appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
        appMenu.submenu?.addItem(NSMenuItem.separator())
        let services = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        self.servicesMenu = NSMenu()
        services.submenu = self.servicesMenu
        appMenu.submenu?.addItem(services)
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(NSMenuItem(title: "Hide \(appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"))
        let hideOthers = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthers.keyEquivalentModifierMask = [.command, .option]
        appMenu.submenu?.addItem(hideOthers)
        appMenu.submenu?.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""))
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(NSMenuItem(title: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        
        let windowMenu = NSMenuItem()
        windowMenu.submenu = NSMenu(title: "Window")
        windowMenu.submenu?.addItem(NSMenuItem(title: "Minmize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"))
        windowMenu.submenu?.addItem(NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""))
        windowMenu.submenu?.addItem(NSMenuItem.separator())
        windowMenu.submenu?.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "m"))
        
        let mainMenu = NSMenu(title: "Main Menu")
        mainMenu.addItem(appMenu)
        mainMenu.addItem(windowMenu)
        return mainMenu
    }
}

class AppDelegate<V: View>: NSObject, NSApplicationDelegate, NSWindowDelegate {
    init(_ contentView: V) {
        self.contentView = contentView
        
    }
    var window: NSWindow!
    var hostingView: NSView?
    var contentView: V
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        hostingView = NSHostingView(rootView: contentView)
        window.contentView = hostingView
        window.makeKeyAndOrderFront(nil)
        window.delegate = self
        NSApp.activate(ignoringOtherApps: true)
    }

}

func getBooks() -> [Book] {
    return [
    Book(author: "John Steinbeck", name: "Grapes of Wrath", year: 1939),
    Book(author: "George Orwell", name: "1984", year: 1949),
    Book(author: "Harper Lee", name: "To Kill a Mockingbird", year: 1960),
    Book(author: "F. Scott Fitzgerald", name: "The Great Gatsby", year: 1925),
    Book(author: "Jane Austen", name: "Pride and Prejudice", year: 1813),
    Book(author: "J.K. Rowling", name: "Harry Potter and the Sorcerer's Stone", year: 1997),
    Book(author: "J.R.R. Tolkien", name: "The Hobbit", year: 1937),
    Book(author: "Mark Twain", name: "Adventures of Huckleberry Finn", year: 1884),
    Book(author: "Herman Melville", name: "Moby-Dick", year: 1851),
    Book(author: "Ray Bradbury", name: "Fahrenheit 451", year: 1953),
    Book(author: "Leo Tolstoy", name: "War and Peace", year: 1869),
    Book(author: "Charles Dickens", name: "A Tale of Two Cities", year: 1859),
    Book(author: "Mary Shelley", name: "Frankenstein", year: 1818),
    Book(author: "J.D. Salinger", name: "The Catcher in the Rye", year: 1951),
    Book(author: "Gabriel García Márquez", name: "One Hundred Years of Solitude", year: 1967),
    Book(author: "Fyodor Dostoevsky", name: "Crime and Punishment", year: 1866),
    Book(author: "Miguel de Cervantes", name: "Don Quixote", year: 1605),
    Book(author: "Vladimir Nabokov", name: "Lolita", year: 1955),
    Book(author: "Kurt Vonnegut", name: "Slaughterhouse-Five", year: 1969),
    Book(author: "C.S. Lewis", name: "The Lion, the Witch, and the Wardrobe", year: 1950),
    Book(author: "Aldous Huxley", name: "Brave New World", year: 1932),
    Book(author: "Ernest Hemingway", name: "The Old Man and the Sea", year: 1952),
    Book(author: "William Golding", name: "Lord of the Flies", year: 1954),
    Book(author: "Margaret Atwood", name: "The Handmaid's Tale", year: 1985),
    Book(author: "Toni Morrison", name: "Beloved", year: 1987),
    Book(author: "Khaled Hosseini", name: "The Kite Runner", year: 2003),
    Book(author: "Suzanne Collins", name: "The Hunger Games", year: 2008),
    Book(author: "F. Scott Fitzgerald", name: "Tender Is the Night", year: 1934),
    Book(author: "Philip K. Dick", name: "Do Androids Dream of Electric Sheep?", year: 1968),
    Book(author: "Daphne du Maurier", name: "Rebecca", year: 1938),
    Book(author: "Douglas Adams", name: "The Hitchhiker's Guide to the Galaxy", year: 1979),
    Book(author: "J.R.R. Tolkien", name: "The Fellowship of the Ring", year: 1954),
    Book(author: "Stephen King", name: "The Shining", year: 1977),
    Book(author: "John Green", name: "The Fault in Our Stars", year: 2012),
    Book(author: "John Green", name: "Looking for Alaska", year: 2005),
    Book(author: "John Green", name: "Paper Towns", year: 2008),
    Book(author: "John Green", name: "An Abundance of Katherines", year: 2006),
    Book(author: "John Green", name: "Turtles All the Way Down", year: 2017),
    Book(author: "John Green", name: "Will Grayson, Will Grayson", year: 2010),
    Book(author: "John Green", name: "The Anthropocene Reviewed", year: 2021)
]
}
