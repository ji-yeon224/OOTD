//
//  LoginError.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation

struct NetworkError: Error {
    
    let statusCode: Int
    
    var description: String
}

