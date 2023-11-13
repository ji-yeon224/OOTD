//
//  LoginError.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation

enum LoginError: Int, Error {
    
    case invalidInput = 400
    case noExistUser = 401
    case serverError = 500
    
}

