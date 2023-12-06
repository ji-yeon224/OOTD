//
//  PostDeleteError.swift
//  TimeLine
//
//  Created by 김지연 on 12/2/23.
//

import Foundation
enum PostDeleteError: Int, Error {
    
    case wrongAuth = 401
    case forbidden = 403
    case alreadyDelete = 410
    case expireToken = 419
    case noAuthorization = 445
}
extension PostDeleteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .alreadyDelete:
            return "이미 삭제된 게시글입니다."
        case .expireToken:
            return "엑세스 토큰이 만료되었습니다."
        case .noAuthorization:
            return "삭제 권한이 없습니다."
        }
    }
}
