//
//  LikeError.swift
//  TimeLine
//
//  Created by 김지연 on 12/11/23.
//

import Foundation
enum LikeError: Int, Error {
    
    case noExistData = 410
    
}

extension LikeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noExistData:
            return "게시글을 찾을 수 없습니다."
        }
    }
}
