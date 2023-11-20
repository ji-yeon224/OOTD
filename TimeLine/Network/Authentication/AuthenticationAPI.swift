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
    case join(joinInfo: Join)
    case emailValidation(email: String)
    case refresh, content
    case withdraw
}

extension AuthenticationAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "login"
        case .join: return "join"
        case .emailValidation: return "validation/email"
        case .refresh: return "refresh"
        case .content: return "content"
        case .withdraw: return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .join, .emailValidation:
            return .post
        case .refresh, .content, .withdraw:
            return .get
            
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let userInfo): 
            return .requestJSONEncodable(userInfo)
        case .join(let joinInfo):
            return .requestJSONEncodable(joinInfo)
        case .emailValidation(let email):
            return .requestJSONEncodable(["email": email])
        case .refresh, .content: return .requestPlain
        case .withdraw: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .join, .emailValidation:
            return ["Content-Type": "application/json", "SesacKey": APIKey.key]
        case .refresh:
            return [
                "Authorization": UserDefaultsHelper.shared.token ?? "",
                "Refresh": UserDefaultsHelper.shared.refreshToken ?? "",
                "SesacKey": APIKey.key]
        case .content, .withdraw:
            return [
                "Authorization": UserDefaultsHelper.shared.token ?? "",
                "SesacKey": APIKey.key
            ]
        }
    }
    
    
    
    
}
