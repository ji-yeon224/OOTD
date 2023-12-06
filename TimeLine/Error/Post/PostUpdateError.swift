//
//  PostUpdateError.swift
//  TimeLine
//
//  Created by 김지연 on 12/4/23.
//

import Foundation

enum PostUpdateError: Int, Error {
    case invalidRequest = 400
    case wrongAuth = 401
    case forbidden = 403
    case alreadyDelete = 410
    case expireToken = 419
    case noAuthorization = 445
}

extension PostUpdateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .alreadyDelete:
            return "이미 삭제된 게시글입니다."
        case .expireToken:
            return "엑세스 토큰이 만료되었습니다."
        case .noAuthorization:
            return "수정 권한이 없습니다."
        }
    }
}
