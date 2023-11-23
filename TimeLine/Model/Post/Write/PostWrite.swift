//
//  PostWrite.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation
import Moya

struct PostWrite: Encodable {
    
    var title: String
    var content: String
    var file: [Data?]
    var product_id: String
    
    func convertToMap() -> [String: Data] {
        var param: [String: Data] = [:]
        
        param["title"] = self.title.data(using: .utf8) ?? Data()
        param["content"] = self.content.data(using: .utf8) ?? Data()
        param["product_id"] = self.product_id.data(using: .utf8) ?? Data()
        
        return param
    }
    
}
