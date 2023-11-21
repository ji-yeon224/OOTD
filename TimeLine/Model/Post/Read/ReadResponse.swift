//
//  ReadResponse.swift
//  TimeLine
//
//  Created by 김지연 on 11/21/23.
//

import Foundation
struct ReadResponse: Codable {
    let data: [Post]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

// MARK: - Datum
//struct Posts: Codable {
//    let likes, image, hashTags, comments: [String]
//    let id: String
//    let creator: Creator
//    let time, title, content, productID: String
//
//    enum CodingKeys: String, CodingKey {
//        case likes, image, hashTags, comments
//        case id = "_id"
//        case creator, time, title, content
//        case productID = "product_id"
//    }
//}
//
//// MARK: - Creator
//struct Creator: Codable {
//    let id, nick: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case nick
//    }
//}
