//
//  PostDeleteError.swift
//  TimeLine
//
//  Created by 김지연 on 12/2/23.
//

import Foundation
enum PostDeleteError: Int, Error {
    
    case alreadyDelete = 410
    case noAuthorization = 445
}
extension PostDeleteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .alreadyDelete:
            return "이미 삭제된 게시글입니다."
        case .noAuthorization:
            return "삭제 권한이 없습니다."
        }
    }
}
