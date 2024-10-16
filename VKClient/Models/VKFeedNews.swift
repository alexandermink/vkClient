//
//  VKFeedNews.swift
//  VKClient
//
//  Created by Александр Минк on 01.10.2024.
//

import Foundation

// Структуры для модели постов
struct VKFeedNews: Codable {
    let response: Response?
}


// MARK: - Response
struct Response: Codable {
    let items: [ResponseItem]?
    let profiles: [Profile]?
    let groups: [Group]?
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}


// MARK: - Profile
struct Profile: Codable {
    let id: Int?
    let firstName, lastName: String?
    let photo50: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
}


// MARK: - Group
struct Group: Codable {
    let id: Int?
    let name: String?
    let photo50: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo50 = "photo_50"
    }
}


// MARK: - ResponseItem (Post)
struct ResponseItem: Codable {
    let postID: Int?
    let sourceID, date: Int?
    let text: String?
    let likes: Likes?
    let views: Views?
    let attachments: [Attachment]? // Вложения для постов

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case sourceID = "source_id"
        case date, text, likes, views, attachments
    }
}


// MARK: - Attachment
struct Attachment: Codable {
    let type: String?
    let photo: Photo? // Добавляем поддержку фото вложений
}


// MARK: - Photo
struct Photo: Codable {
    let sizes: [PhotoSize]?
    
    var bestSize: PhotoSize? {
        return sizes?.last // Получаем наибольший доступный размер
    }
}


// MARK: - PhotoSize
struct PhotoSize: Codable {
    let url: String?
    let width, height: Int?
}


// MARK: - Likes
struct Likes: Codable {
    let count: Int?
    let userLikes: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}


// MARK: - Views
struct Views: Codable {
    let count: Int?
}


// Структура для декодирования ответа VK API на запрос о лайках
struct LikeResponse: Codable {
    let response: LikeResponseBody?
}


struct LikeResponseBody: Codable {
    let likes: Int?
}
