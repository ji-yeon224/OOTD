//
//  CommonError.swift
//  TimeLine
//
//  Created by 김지연 on 11/16/23.
//

import Foundation

enum CommonError: Int, Error {
    
    case wrongKey = 420
    case overCall = 429
    case invalidAccess = 444
    
    
}

extension CommonError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            case .wrongKey:
                return "잘못된 키 값입니다."
            case .overCall:
                return "과호출입니다."
            case .invalidAccess:
                return "잘못된 접근입니다."
        }
       
    }
}
