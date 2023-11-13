//
//  LoginToken.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation

struct LoginToken: Decodable {
    var token: String
    var refreshToken: String
    
}
