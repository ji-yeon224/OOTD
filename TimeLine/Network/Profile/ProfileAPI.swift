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
    case update(data: ProfileUpdateRequest)
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
        case .update(let data):
            return .uploadMultipart(convertToMultipart(data: data))
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

extension ProfileAPI {
    
    private func convertToMultipart(data: ProfileUpdateRequest) -> [MultipartFormData] {
        
        var multipart: [MultipartFormData] = []
        
        let params = data.convertToMap()
        
        for param in params {
            multipart.append(MultipartFormData(provider: .data(param.value), name: param.key))

        }
        if let profile = data.profile {
            multipart.append(MultipartFormData(provider: .data(profile), name: "profile", fileName: "image.jpeg", mimeType: "image/jpg"))
        } else {
            print("profile nil")
            multipart.append(MultipartFormData(provider: .data(Data()), name: "profile"))
        }
        
        return multipart
    }
    
}

extension ProfileAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}
