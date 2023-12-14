//
//  MyProfileResponse.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation

struct MyProfileResponse: Decodable {
    
    let posts: [String]
    let _id: String
    let email: String
    let nick: String
    let birthDay: String
    var profile: String?
    
    
    
}
