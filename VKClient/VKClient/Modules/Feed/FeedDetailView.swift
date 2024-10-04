//
//  FeedDetailView.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import SwiftUI

struct FeedDetailView: View {
    @ObservedObject var viewModel: FeedViewModel
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Отображение текста поста
            if let text = post.text {
                Text(text)
                    .font(.body)
            }

            // Отображение изображений, если они есть
            if let imageUrls = post.imageUrls, !imageUrls.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(imageUrls, id: \.self) { imageUrl in
                            AsyncImage(url: imageUrl) { image in
                                image.resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 150, height: 150)
                                     .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }

            // Кнопка для управления лайками и отображение просмотров
            HStack {
                Button(action: {
                    viewModel.toggleLike(for: post) // При нажатии вызываем toggleLike
                }) {
                    HStack {
                        Image(systemName: post.userLikes ? "heart.fill" : "heart")
                            .foregroundColor(post.userLikes ? .red : .gray)
                        Text("\(post.likes ?? 0) лайков")
                    }
                }

                Spacer()

                if let views = post.views {
                    HStack {
                        Image(systemName: "eye.fill")
                            .foregroundColor(.gray)
                        Text("\(views) просмотров")
                    }
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle(post.authorName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

