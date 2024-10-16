//
//  FeedView.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.posts, id: \.id) { post in
                NavigationLink(destination: FeedDetailView(viewModel: viewModel, post: post)) {
                    FeedRow(post: post)
                        .listRowInsets(EdgeInsets())
                        .background(.clear)
                }
            }
            .listStyle(.plain)
            .background(.clear)
            .navigationTitle("Новости")
            .onAppear {
                viewModel.fetchPosts()
            }
            .refreshable {
                viewModel.fetchPosts()
            }
        }
        .background(.white)
    }
}

#Preview {
    FeedView()
}
