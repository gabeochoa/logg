// The Swift Programming Language
// https://docs.swift.org/swift-book


import Cocoa
import SwiftUI

public func closeButtonAction(){
    exit(0)
}

struct RatingChart: View {
    var book: Book

    var rating_heights: [Float] {
        let all_reviews = data.reviews.filter { $0.book_id == book.id }
        
        // Use reduce to count occurrences of each rating
        let starCounts = all_reviews.reduce(into: [0, 0, 0, 0, 0]) { 
            counts, review in
                switch review.rating {
                case .one:
                    counts[0] += 1
                case .two:
                    counts[1] += 1
                case .three:
                    counts[2] += 1
                case .four:
                    counts[3] += 1
                case .five:
                    counts[4] += 1
                default:
                    break
                }
        }
        
        // Convert to proportions, avoid division by zero
        let totalReviews = Float(all_reviews.count)
        return totalReviews == 0 
            ? [0, 0, 0, 0, 0] 
            : starCounts.map { Float($0) / totalReviews }
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(rating_heights.indices, id: \.self){
                index in 
                    Rectangle()
                    .fill(theme.placeholder)
                    .frame(width: 40, height: CGFloat( (50 * rating_heights[index]) + 5) )
            }
            Text("3.5")
            .font(.largeTitle)
            .foregroundColor(.yellow)

        }
    }
}

struct BookDetailPage: View {
    var book: Book

    var rating_count: Int {
        return data.reviews.filter { 
            review in review.book_id == book.id
        }.count
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Spacer() 

                    Text(book.name)
                        .font(.largeTitle)
                    HStack {
                        Text(String("(\(book.year))"))
                            .font(.body)
                        Text(book.author)
                            .font(.title)
                    }

                    Spacer() 
                }

                RoundedRectangle(cornerRadius: 5)
                    .fill(theme.placeholder)
                    .frame(width: 75, height: 100)
            }

            Spacer()

            Text(placeholder_desc)
                .font(.body)

            HStack {
                Text("Ratings")
                    .font(.headline)
                Text("\(rating_count)")
                    .font(.body)
            }
            
            RatingChart(book: book)
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var activeBookPage: UUID? = nil
    @State private var searchSheetOpen: Bool = false

    var hasActiveBookPage: Bool {
        return activeBookPage != nil
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    activeBookPage = data.books[0].id
                    }
                ){
                    Text("Example")
                }
                Button(action: {
                    searchSheetOpen = true
                }){
                    Text("+")
                }
                .sheet(isPresented: $searchSheetOpen){
                    SearchSheet(bookPage: $activeBookPage)
                    .frame(height:300)
                }
                .sheet(isPresented: Binding<Bool>(
                    get: { activeBookPage != nil },
                    set: { newValue in
                        if !newValue { activeBookPage = nil } 
                    })) {
                    if let bookID = activeBookPage {
                        BookDetailPage(
                            book: bookFromID(id: bookID)
                        )
                    }
                }
                Button(action: closeButtonAction){
                    Text("Close")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

NSApplication.shared.run {
    VStack{
        ContentView()

        // closing the application with the stoplight
        // doesnt close swift-frontend 
        // 
        // so this button makes that easier 
        Button(action: closeButtonAction){
            Text("Close")
        }
    }
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
