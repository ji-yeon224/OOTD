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
    

    
}

