//
//  LoginError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum LoginError: Int, Error {
    
    case emptyValue = 400
    case noExistUser = 401
    case wrongKey = 420
    case overCall = 429
    case invalidAccess = 444
    case serverError = 500
    
}

extension LoginError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "이메일 또는 비밀번호를 확인해주세요."
        case .noExistUser:
            return "가입되지 않은 회원입니다."
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
