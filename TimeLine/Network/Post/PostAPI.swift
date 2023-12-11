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
    case read(productId: String, limit: Int, next: String?)
    case delete(id: String)
    case update(id: String, data: PostWrite)
    case like(id: String)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .write, .read:
            return "post"
        case .delete(let id):
            return "post/\(id)"
        case .update(let id, _):
            return "post/\(id)"
        case .like(let id):
            return "post/like/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .write, .like:
            return .post
        case .read:
            return .get
        case .delete:
            return .delete
        case .update:
            return .put
        }
    }
    
    
    var task: Moya.Task {
        switch self {
        case .write(let data), .update(_, let data):
            return .uploadMultipart(convertToMultipart(data: data))
        case .read(let id, let limit, let next):
            var parameters: [String:Any] = ["product_id" : id, "limit": limit]
            if let next = next {
                parameters["next"] = next
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .delete, .like: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .write, .update:
            return [
                "Content-Type": "multipart/form-data",
                "SesacKey": APIKey.key,
                "Authorization": UserDefaultsHelper.token
            ]
        case .read, .delete, .like:
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
            multipart.append(MultipartFormData(provider: .data(img), name: "file", fileName: "image.jpeg", mimeType: "image/jpg"))
        }
        
        
        return multipart
    }
    
    
}
extension PostAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}
