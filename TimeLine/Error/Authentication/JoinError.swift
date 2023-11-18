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
}

extension JoinError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "필수 입력 값을 입력해주세요."
        case .existUser:
            return "이미 가입한 유저입니다."
        
        }
    }
    
}
