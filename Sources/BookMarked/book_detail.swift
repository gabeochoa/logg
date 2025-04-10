import SwiftUI

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
            ForEach(rating_heights.indices, id: \.self) {
                index in
                Rectangle()
                    .fill(theme.placeholder)
                    .frame(width: 40, height: CGFloat((50 * rating_heights[index]) + 5))
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

            ExpandableText(placeholder_desc)
                .lineLimit(3)

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
