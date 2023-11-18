//
//  WithdrawError.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

enum WithdrawError: Int, Error {
    
    case invalidToken = 401
    case forbidden = 403
    case expireToken = 419
   
    
}

extension WithdrawError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "인증할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "금지된 접근입니다."
        case .expireToken:
            return "엑세스 토큰이 만료되었습니다."
       
        }
    }
    
}
