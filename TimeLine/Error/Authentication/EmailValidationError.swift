//
//  EmailValidationError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum EmailValidationError: Int, Error {
    
    case emptyValue = 400
    case alreadyExist = 409
    case wrongKey = 420
    case overCall = 429
    case invalidAccess = 444
    case serverError = 500
}

extension EmailValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "이메일을 입력해주세요!"
        case .alreadyExist:
            return "이미 사용하고 있는 이메일입니다."
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
