//
//  LoginError.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation

enum NetworkError: Int, Error {
    
    case wrongKey = 420
    case overCall = 429
    case wrongAccess = 444
    
}

