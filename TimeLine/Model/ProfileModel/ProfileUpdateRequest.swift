//
//  ProfileUpdateRequest.swift
//  TimeLine
//
//  Created by 김지연 on 12/13/23.
//

import Foundation

struct ProfileUpdateRequest: Encodable {
    let nick: String?
    let profile: Data?
    
    func convertToMap() -> [String: Data] {
        var param: [String: Data] = [:]
        param["nick"] = self.nick?.data(using: .utf8) ?? Data()
        return param
    }
}
