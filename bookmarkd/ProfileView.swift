//
//  ProfileView.swift
//  bookmarkd
//
//  Created by gabeochoa on 4/19/25.
//

import SwiftUI

struct ProfileSocialLink: View {
    @Environment(\.openURL) var openURL

    let link: SocialAccountLink

    var body: some View {
        HStack{
            Image(systemName: "link") 
                .resizable()
                .frame(width: 15, height: 15)
            /* Link("\(link.content)", destination: link.content) */
            Button("\(link.content)"){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    openURL(link.content)
                }
            }
        }
    }
}

struct ProfileSocialSheet: View {
    var user: User 

    var body: some View {
        List {
            ForEach(user.social_accounts, id: \.id){
                account_link in 
                    ProfileSocialLink(link: account_link)
            }
        }
    }
}

struct ProfileHeaderView: View {
    @State private var socialSheetOpen: Bool = false

    var user: User 

    var body: some View {
        HStack {
            Image(user.pfp) 
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                // TODO make it round
                .border(.gray, width: 1)

            VStack(alignment: .leading, spacing: 0) {
                Text(user.name)
                    .font(.largeTitle)
                Text("232 books")
                    .font(.body)
                    .foregroundColor(.secondary)

                Button(action: {
                    socialSheetOpen.toggle()
                }) {
                    HStack(alignment: .center, spacing: 2){
                        Image(systemName: "square.fill") 
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.blue)
                        Image(systemName: "square.fill") 
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.red)
                        Image(systemName: "square.fill") 
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .sheet(isPresented: $socialSheetOpen){
                        ProfileSocialSheet(user: user)
                            .presentationDetents([.medium, .large])
                    }
                }
            }
        }
        .padding(.horizontal, 10)
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

struct ProfileView: View {
    var user: User

    var reviews: [Review] {
        return reviewsForUserID(id: user.id)
    }

    var body: some View {
        VStack (alignment: .leading) { 
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
            .listStyle(.plain)
        }
        .padding(.horizontal, 10)
    }
}


#Preview {
    ProfileView(user: userForUserName(name: "choicehoney")!)
}
