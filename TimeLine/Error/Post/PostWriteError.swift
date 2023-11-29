//
//  PostWriteError.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation

enum PostWriteError: Int, Error {
    case invalidRequest = 400
    case wrongAuth = 401
    case forbidden = 403
    case saveError = 410
    case expireToken = 419
}

extension PostWriteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "이미지 파일의 용량을 확인해주세요."
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .saveError:
            return "DB 서버에 문제가 발생하여 게시글을 저장할 수 없습니다."
        case .expireToken:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}
