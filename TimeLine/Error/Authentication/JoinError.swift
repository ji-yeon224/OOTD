//
//  JoinError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum JoinError: Int, Error {
    
    case emptyValue = 400
    case existUser = 409
    case wrongKey = 420
    case overCall = 429
    case invalidAccess = 444
    case serverError = 500
}

extension JoinError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "필수 입력 값을 입력해주세요."
        case .existUser:
            return "이미 가입한 유저입니다."
        case .wrongKey:
            return "잘못된 키 값입니다."
        case .overCall:
            return "과호출입니다."
        case .invalidAccess:
            return "잘못된 접근입니다."
        case .serverError:
            return "서버에 문제가 발생하였습니다."
        }
    }
    
}
