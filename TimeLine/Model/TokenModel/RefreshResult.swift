//
//  RefreshResult.swift
//  TimeLine
//
//  Created by 김지연 on 11/16/23.
//

import Foundation

enum RefreshResult {
    case success(token: String)
    case login(error: NetworkError)
    case error
}
