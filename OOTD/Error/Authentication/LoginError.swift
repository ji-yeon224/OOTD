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
    
    
}

extension LoginError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "이메일과 비밀번호를 입력해주세요."
        case .noExistUser:
            return "이메일 또는 비밀번호가 일치하지 않습니다."
        
        }
    }
    
}
