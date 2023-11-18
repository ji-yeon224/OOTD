//
//  RefreshError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum RefreshError: Int, Error {
    
    case wrongAuth = 401
    case fobidden = 403
    case noExpire = 409
    case expireRefreshToken = 418
    }

extension RefreshError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .fobidden:
            return "접근 권한이 없습니다."
        case .noExpire:
            return "토큰이 만료되지 않았습니다."
        case .expireRefreshToken:
            return "토큰이 만료되어 다시 로그인을 해주세요."
        }
    }
    
}
