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

struct ProfileSocialRow: View {
    @State private var socialSheetOpen: Bool = false

    var user: User 

    var body: some View {
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

struct ProfileNumbersRow : View {

    var user: User 

    var review_count: Int {
        return data.reviews.filter {
            review in review.user_id == user.id
        }.count
    }

    var follower_count: Int {
        return getFollowersForID(user.id).count
    }

    var following_count: Int {
        return getFollowingForID(user.id).count
    }

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack{
                Text("\(review_count)")
                    .font(.body)
                Text("books")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            VStack {
                Text("\(follower_count)")
                    .font(.body)
                Text("followers")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            VStack {
                Text("\(following_count)")
                    .font(.body)
                Text("following")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
    }
}

struct ProfileHeaderView: View {

    var user: User 

    var body: some View {
        HStack {
            Image(user.pfp) 
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                // TODO make it round
                .border(.gray, width: 1)

            VStack(alignment: .center, spacing: 0) {
                Text(user.name)
                    .font(.largeTitle)

                ProfileNumbersRow(user: user)
                ProfileSocialRow(user: user)
            }
            .frame(maxWidth: .infinity)
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
        return reviewsForUserID(user.id)
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
                            book: bookFromID( review.id),
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
    ProfileView(user: userForUserName( "choicehoney")!)
}
