//
//  ContentError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum ContentError: Int, Error {
    
    case invalidToken = 401
    case forbidden = 403
    case expireToken = 419
    
//    case wrongKey = 420
//    case overCall = 429
//    case invalidAccess = 444
    
    
}

extension ContentError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "인증할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .expireToken:
            return "엑세스 토큰이 만료되었습니다."
//        case .wrongKey:
//            return "잘못된 키 값입니다."
//        case .overCall:
//            return "과호출입니다."
//        case .invalidAccess:
//            return "잘못된 접근입니다."
        }
    }
    
}
