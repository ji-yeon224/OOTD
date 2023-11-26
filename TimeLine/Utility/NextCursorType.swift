//
//  NextCursorType.swift
//  TimeLine
//
//  Created by 김지연 on 11/25/23.
//

import Foundation

@propertyWrapper
struct NextCursorType {
    
    var wrappedValue: String
    
}

extension NextCursorType: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let nextCursor = try? container.decode(String.self) {
            wrappedValue = nextCursor
        } else {
            wrappedValue = "0"
        }
    }
}
