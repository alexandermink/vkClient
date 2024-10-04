//
//  Post.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import Foundation

// Структура для отображения постов
struct Post: Hashable {
    let id: String
    let authorName: String
    let avatarURL: URL?
    let date: Date
    let text: String?
    var likes: Int?
    var userLikes: Bool
    let views: Int?
    let imageUrls: [URL]?
    let sourceType: SourceType
    let sourceID: Int

    enum SourceType {
        case profile
        case group
    }
}
