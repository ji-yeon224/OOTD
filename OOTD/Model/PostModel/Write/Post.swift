//
//  WriteResponse.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation

struct Post: Codable, Hashable {
    let likes, image, hashTags: [String]
    let comments: [Comment]
    let id: String
    let creator: Creator
    let time, title, content, productID: String

    enum CodingKeys: String, CodingKey {
        case likes, image, hashTags, comments
        case id = "_id"
        case creator, time, title, content
        case productID = "product_id"
    }
}



//struct WriteResponse: Codable {
//    var data: [Post?]?
//    let nextCursor: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case data
//        case nextCursor = "next_cursor"
//    }
//}
//
//
//struct Post: Codable {
//    let likes, image, hashTags, comments: [String?]
//    let id: String?
//    let creator: Creator?
//    let time, title, content, productID: String?
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
