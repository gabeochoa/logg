import SwiftUI

let placeholder_desc =
    "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"

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

enum RatingStar: Int {
    case unset
    case one = 1
    case two, three, four, five
}

struct Review: Identifiable {
    let id: UUID = UUID()
    let book_id: UUID
    let user_id: UUID
    let content: String
    let rating: RatingStar

    // TODO make a lightweight version so we dont have to load
    // this entire object to make the chart
    init(book_id: UUID, user_id: UUID, content: String, rating: RatingStar = .unset) {
        self.book_id = book_id
        self.user_id = user_id
        self.content = content
        self.rating = rating
    }
}

struct Data {
    let books: [Book]
    let users: [User]
    var reviews: [Review]

    init() {
        self.books = getBooks()

        self.users = [
            User(name: "choicehoney"),
            User(name: "bagelseed"),
            User(name: "hotpapi"),
        ]

        self.reviews = [
            Review(
                book_id: books[0].id, user_id: users[0].id, content: "Review 1",
                rating: RatingStar.three),
            Review(
                book_id: books[0].id, user_id: users[1].id, content: "Review 2 🤷",
                rating: RatingStar.two),
            Review(
                book_id: books[0].id, user_id: users[2].id, content: "Review 3 🥵",
                rating: RatingStar.four),
        ]

        generateFakeReviews()
    }

    mutating func generateFakeReviews() {
        let reviewContents = [
            "Loved this book! 📚",
            "Not bad, but could be better 🤔",
            "Amazing read! 😍",
            "Pretty decent, but a bit slow at times ⏳",
            "I didn't enjoy this one... 😕",
            "Incredible! Will read again 🔁",
            "A rollercoaster of emotions! 😳",
            "A solid read from me ⭐⭐",
            "I couldn't put this one down! 🔥",
            "Too long, didn't finish... 🥱",
        ]

        for book in self.books {
            for user in self.users {
                let randomRating = RatingStar(rawValue: Int.random(in: 1...5)) ?? .unset
                let randomContent = reviewContents.randomElement() ?? "No review content"
                let review = Review(
                    book_id: book.id, user_id: user.id, content: randomContent, rating: randomRating
                )
                self.reviews.append(review)
            }
        }
    }
}

@MainActor
var data: Data = Data()

struct Theme {
    let space_cadet = Color(hex: "2B2D42")
    let cool_gray = Color(hex: "8D99AE")

    let background = Color(hex: "8D99AE")
    let placeholder = Color(hex: "8D99AE")
}

let theme = Theme()

func getBooks() -> [Book] {
    return [
        Book(author: "John Steinbeck", name: "Grapes of Wrath", year: 1939),
        Book(
            author: "T. J. Llewelyn (Thomas Jeffery Llewelyn) Prichard",
            name:
                "The new Aberstwyth guide to the waters, bathing houses, public walks, and amusements; including historical notices and general information connected with the town, castle ruins, rivers, Havod, the Dev",
            year: 1545),
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
        Book(author: "John Green", name: "The Anthropocene Reviewed", year: 2021),
    ]
}

@MainActor
func bookFromID(id: UUID) -> Book {
    let results = (data.books.filter { book in book.id == id })
    if results.isEmpty {
        print("Was not able to find ", id)
        return data.books[0]
    }
    return results[0]
}
