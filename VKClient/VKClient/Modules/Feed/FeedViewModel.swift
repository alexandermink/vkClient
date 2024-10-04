//
//  FeedViewModel.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import Combine
import Foundation

class FeedViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    private let apiService = VKAPIService()
    
    func fetchPosts() {
        let parameters: [String: Any] = [
            "filters": "post",
            "count": 20
        ]
        
        apiService.performRequest(method: "newsfeed.get", parameters: parameters, responseType: VKFeedNews.self) { result in
            switch result {
            case .success(let vkResponse):
                if let items = vkResponse.response?.items {
                    self.posts = items.map { self.createPost(from: $0, vkResponse: vkResponse) }
                }
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    func toggleLike(for post: Post) {
        let method = post.userLikes ? "likes.delete" : "likes.add"
        let parameters: [String: Any] = [
            "type": "post",
            "owner_id": post.sourceID,
            "item_id": post.id
        ]
        
        apiService.performRequest(method: method, parameters: parameters, responseType: LikeResponse.self) { result in
            switch result {
            case .success(let likeResponse):
                if let likes = likeResponse.response?.likes {
                    if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                        self.posts[index].likes = likes
                        self.posts[index].userLikes.toggle()
                    }
                }
            case .failure(let error):
                print("Error toggling like: \(error)")
            }
        }
    }
    
    private func createPost(from item: ResponseItem, vkResponse: VKFeedNews) -> Post {
        let (authorName, avatarURL, sourceType) = getAuthorInfo(from: item, vkResponse: vkResponse)
        let imageUrls: [URL]? = item.attachments?.compactMap { attachment in
            guard let urlString = attachment.photo?.bestSize?.url else { return nil }
            return URL(string: urlString)
        }
        
        return Post(
            id: String(item.postID ?? 0),
            authorName: authorName,
            avatarURL: URL(string: avatarURL ?? ""),
            date: Date(timeIntervalSince1970: TimeInterval(item.date ?? 0)),
            text: item.text,
            likes: item.likes?.count,
            userLikes: item.likes?.userLikes == 1,
            views: item.views?.count,
            imageUrls: imageUrls,
            sourceType: sourceType,
            sourceID: item.sourceID ?? 0
        )
    }
    
    private func getAuthorInfo(from item: ResponseItem, vkResponse: VKFeedNews) -> (String, String?, Post.SourceType) {
        if item.sourceID ?? 0 < 0 {
            let groupID = abs(item.sourceID ?? 0)
            if let group = vkResponse.response?.groups?.first(where: { $0.id == groupID }) {
                return (group.name ?? "Unknown Group", group.photo50, .group)
            }
        } else {
            let profileID = item.sourceID ?? 0
            if let profile = vkResponse.response?.profiles?.first(where: { $0.id == profileID }) {
                return ("\(profile.firstName ?? "Unknown") \(profile.lastName ?? "")", profile.photo50, .profile)
            }
        }
        return ("Unknown", nil, .profile)
    }
}
