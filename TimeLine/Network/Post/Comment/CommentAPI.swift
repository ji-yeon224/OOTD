//
//  CommentAPI.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation
import Moya

enum CommentAPI {
    case write(id: String, data: CommentRequest)
    case update(id: String, commentID: String, data: CommentRequest)
    case delete(id: String, commentID: String)
}

extension CommentAPI: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .write(let id, _):
            return "post/\(id)/comment"
        case .update(let id, let commentID, _):
            return "post/\(id)/comment/\(commentID)"
        case .delete(let id, let commentID):
            return "post/\(id)/comment/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .write:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .write(_, let data):
            return .requestJSONEncodable(data)
        case .update(_, _, let data):
            return .requestJSONEncodable(data)
        case .delete:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .write, .update:
            return [
                "Authorization": UserDefaultsHelper.token,
                "Content-Type": "application/json",
                "SesacKey": APIKey.key]
        case .delete:
            return [
                "Authorization": UserDefaultsHelper.token,
                "SesacKey": APIKey.key
            ]
        }
    }
    
    
}
