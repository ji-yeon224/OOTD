//
//  LikeResponse.swift
//  TimeLine
//
//  Created by 김지연 on 12/11/23.
//

import Foundation
struct LikeResponse: Decodable {
    let like: Bool
    
    enum CodingKeys: String, CodingKey {
        case like = "like_status"
    }
}
