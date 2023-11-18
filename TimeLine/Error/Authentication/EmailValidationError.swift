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
    
}

extension EmailValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "이메일을 입력해주세요!"
        case .alreadyExist:
            return "이미 사용하고 있는 이메일입니다."
        
        }
    }
}
