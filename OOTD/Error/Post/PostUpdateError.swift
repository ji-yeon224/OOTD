//
//  PostUpdateError.swift
//  TimeLine
//
//  Created by 김지연 on 12/4/23.
//

import Foundation

enum PostUpdateError: Int, Error {
    case invalidRequest = 400
    case alreadyDelete = 410
    case noAuthorization = 445
}

extension PostUpdateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .alreadyDelete:
            return "이미 삭제된 게시글입니다."
        case .noAuthorization:
            return "수정 권한이 없습니다."
        }
    }
}
