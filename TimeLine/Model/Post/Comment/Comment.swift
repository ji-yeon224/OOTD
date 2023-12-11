//
//  CommentResponse.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation

struct Comment: Codable, Hashable {
    let id, time, content: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case time, content, creator
    }
    
}
