//
//  CommentError.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation

enum CommentError: Int, Error {
    case emptyData = 400
    case noExistData = 410
    case noAuthorization = 445
    
}

extension CommentError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "필수 값이 누락되었습니다."
        case .noExistData:
            return "해당 댓글을 찾을 수 없습니다."
        case .noAuthorization:
            return "권한이 없습니다."
        }
    }
}
