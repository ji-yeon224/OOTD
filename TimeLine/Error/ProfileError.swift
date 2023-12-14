//
//  ProfileError.swift
//  TimeLine
//
//  Created by 김지연 on 12/13/23.
//

import Foundation

enum ProfileError: Int, Error {
    case invalidRequest = 400
}

extension ProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest: return "이미지 파일은 1MB 이하로 제한되어 있습니다."
        }
    }
}
