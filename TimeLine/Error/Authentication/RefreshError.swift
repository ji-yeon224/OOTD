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
    
//    case wrongKey = 420
//    case overCall = 429
//    case invalidAccess = 444
//    
    case serverError = 500
}

extension RefreshError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .wrongAuth:
            return "인증할 수 없는 토큰입니다."
        case .fobidden:
            return "금지된 접근입니다."
        case .noExpire:
            return "토큰이 만료되지 않았습니다."
        case .expireRefreshToken:
            return "토큰이 만료되어 다시 로그인을 해주세요."
//        case .wrongKey:
//            return "잘못된 키 값입니다."
//        case .overCall:
//            return "과호출입니다."
//        case .invalidAccess:
//            return "잘못된 접근입니다."
        case .serverError:
            return "서버에 문제가 발생하였습니다."
        }
    }
    
}
