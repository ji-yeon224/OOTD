//
//  ReadResponse.swift
//  TimeLine
//
//  Created by 김지연 on 11/21/23.
//

import Foundation
struct ReadResponse: Codable {
    let data: [Post]
    @NextCursorType var nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.data = try container.decode([Post].self, forKey: .data)
//        if let nextCursor = try? container.decode(String.self, forKey: .nextCursor) {
//            self.nextCursor = nextCursor
//        } else {
//            self.nextCursor = "0"
//        }
//        
//        
//    }
    
}

