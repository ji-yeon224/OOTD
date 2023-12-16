//
//  Creater.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation
struct Creator: Codable, Hashable {
    let id, nick: String
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick
        case profile
    }
}
