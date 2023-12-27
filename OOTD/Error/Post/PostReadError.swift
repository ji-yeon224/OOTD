//
//  PostReadError.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import Foundation

enum PostReadError: Int, Error {
    case invalidRequest = 400
}
extension PostReadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다."
        }
    }
}
