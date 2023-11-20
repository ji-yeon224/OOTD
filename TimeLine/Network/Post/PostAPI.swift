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
    case read
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
        case .read:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .write:
            return [
                "Content-Type": "multipart/form-data",
                "SesacKey": APIKey.key,
                "Authorization": UserDefaultsHelper.shared.token ?? ""
            ]
        case .read:
            return ["Authorization": UserDefaultsHelper.shared.token ?? "",
                    "SesacKey": APIKey.key]
        }
    }
    
    
    
    
    
}

extension PostAPI {
    
    private func convertToMultipart(data: PostWrite) -> [MultipartFormData] {
        
        
        let title = data.title.data(using: .utf8) ?? Data()
        let titleform = MultipartFormData(provider: .data(title), name: "title")
        
        let content = data.content.data(using: .utf8) ?? Data()
        let contentForm = MultipartFormData(provider: .data(content), name: "content")
        let productid = data.product_id.data(using: .utf8) ?? Data()
        let productidForm = MultipartFormData(provider: .data(productid), name: "product_id")
//        let img = data.file ?? Data()
//        let imgForm = MultipartFormData(provider: .data(img), name: "img", fileName: "img.png")
        
        
        
        return [titleform, contentForm, productidForm]
    }
    
    
}
