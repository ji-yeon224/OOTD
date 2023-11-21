//
//  PostAPI.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation
import Moya

enum PostAPI {
    case write(data: PostWrite)
    case read(productId: String, limit: Int)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .write, .read:
            return "post"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .write:
            return .post
        case .read:
            return .get
        }
    }
    
    
    var task: Moya.Task {
        switch self {
        case .write(let data):
            return .uploadMultipart(convertToMultipart(data: data))
        case .read(let id, let limit):
            return .requestParameters(parameters: ["product_id" : id, "limit": limit], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .write:
            return [
                "Content-Type": "multipart/form-data",
                "SesacKey": APIKey.key,
                "Authorization": UserDefaultsHelper.token
            ]
        case .read:
            return ["Authorization": UserDefaultsHelper.token,
                    "SesacKey": APIKey.key]
        }
    }
    
    
    
    
    
}

extension PostAPI {
    
    private func convertToMultipart(data: PostWrite) -> [MultipartFormData] {
        
        var multipart: [MultipartFormData] = []
        
        let params = data.convertToMap()
        
        for param in params {
            multipart.append(MultipartFormData(provider: .data(param.value), name: param.key))

        }
        let files = data.file
        files.forEach {
            guard let img = $0 else { return }
            print(img)
            multipart.append(MultipartFormData(provider: .data(img), name: "file", fileName: "image.jpeg", mimeType: "image/jpg"))
        }
        
        
        return multipart
    }
    
    
}
