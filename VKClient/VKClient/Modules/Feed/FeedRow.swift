//
//  FeedRow.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import SwiftUI

struct FeedRow: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                if let avatarURL = post.avatarURL {
                    AsyncImage(url: avatarURL) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(post.authorName)
                        .font(.headline)
                    Text(post.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let text = post.text {
                        Text(text)
                            .font(.body)
                            .lineLimit(3)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
