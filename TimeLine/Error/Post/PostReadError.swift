//
//  PostReadError.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import Foundation

enum PostReadError: Int, Error {
    case invalidRequest = 400
//    case wrongAuth = 401
//    case forbidden = 403
//    case expireToken = 419
}
extension PostReadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
//        case .wrongAuth:
//            return "인증할 수 없는 토큰입니다."
//        case .forbidden:
//            return "금지된 접근입니다."
//        case .expireToken:
//            return "엑세스 토큰이 만료되었습니다."
        }
    }
}
