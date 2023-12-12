//
//  ProfileAPI.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation
import Moya

enum ProfileAPI {
    case myProfile
    case update
}

extension ProfileAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .myProfile, .update:
            return "profile/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myProfile:
            return .get
        case .update:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myProfile:
            return .requestPlain
        case .update:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myProfile:
            return [
                "Authorization": UserDefaultsHelper.token,
                "SesacKey": APIKey.key
            ]
        case .update:
            return [
                "Authorization": UserDefaultsHelper.token,
                "Content-Type": "application/json",
                "SesacKey": APIKey.key]
        }
    }
    
    
}
