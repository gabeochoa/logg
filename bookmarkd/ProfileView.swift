//
//  ProfileView.swift
//  bookmarkd
//
//  Created by gabeochoa on 4/19/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User 

    var body: some View {
        HStack {
            Image(user.pfp) 
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text("232 books")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ProfileReviewCardStars: View {
    var review: Review 

    func icon_color(index: Int) -> Color {
        return index <= review.rating.rawValue ? .yellow : .gray
    }

    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(icon_color(index: index))
                    .frame(width: 10, height: 10)
            }
        }
    }
}

struct ProfileReviewCard: View {
    var user: User
    var book: Book 
    var review: Review 

    var body: some View {
        VStack {
            HStack{
                Image("book") 
                    .resizable()
                    .frame(width: 50, height: 75)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )

                VStack (alignment: .leading) { 
                    Text(book.name)
                        .font(.headline)
                        .lineLimit(1)
                    ProfileReviewCardStars(review: review)
                    Text("\(review.content)...")
                        .font(.body)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct ProfileView: View {
    var user: User

    var reviews: [Review] {
        return reviewsForUserID(id: user.id)
    }

    var body: some View {
        VStack {
            ProfileHeaderView(user: user)
            ExpandableText(user.bio)
                .lineLimit(3)
            List {
                ForEach(reviews) { 
                    review in
                    NavigationLink(value: review) {
                        ProfileReviewCard(
                            user: user,
                            book: bookFromID(id: review.id),
                            review: review
                        )
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileView(user: userForUserName(name: "choicehoney"))
}
