//
//  TokenError.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation

enum TokenError: Int, Error {
    case wrongAuth = 401
    case forbidden = 403
    case expireToken = 419
}

extension TokenError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .expireToken:
            return "액세스 토큰이 만료되었습니다."
        }
    }
}
