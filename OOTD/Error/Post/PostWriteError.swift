//
//  PostWriteError.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation

enum PostWriteError: Int, Error {
    case invalidRequest = 400
    
    case saveError = 410
}

extension PostWriteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "이미지 파일의 용량을 확인해주세요."
        case .saveError:
            return "DB 서버에 문제가 발생하여 게시글을 저장할 수 없습니다."
        }
    }
}
