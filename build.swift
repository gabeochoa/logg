

// Run any SwiftUI view as a Mac app.

import Cocoa
import SwiftUI

struct Book: Identifiable {
     let id = UUID()
     var author: String
     var name: String
     var year: String = "2024"
 }


private var books = [
    Book(author: "John Steinbeck", name: "Grapes of Wrath"),
    Book(author: "Mei Chen", name: "Harry Potter"),
    Book(author: "John Green", name: "Looking for Alaska"),
    Book(author: "John Green", name: "The Fault in the Stars"),
    Book(author: "John Green", name: "Katherines"),
]

public func closeButtonAction(){
    exit(0)
}


struct SearchResult: View {
    var book: Book

    var body: some View {
        HStack {
            Text(book.name)
                .foregroundColor(.primary)
                .font(.headline)
            Text(book.author)
                .foregroundColor(.secondary)
                .font(.subheadline)
            Text(
                "(\(book.year))"
            )
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .padding(10)
    }
}

struct AddSheet : View {
    var body: some View {
        VStack {
            List {
                ForEach(books) { 
                    book in SearchResult(book: book)
                }
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
