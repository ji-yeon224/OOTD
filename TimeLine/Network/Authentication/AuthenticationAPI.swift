//
//  SeSACAPI.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation
import Moya



enum AuthenticationAPI {
    case login(userInfo: Login)
    
}

extension AuthenticationAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let userInfo):
            let data = Login(email: userInfo.email, password: userInfo.password)
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json", "SesacKey": APIKey.key]
        }
    }
    
    
    
    
}
