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
    var file: Data?
    var product_id: String
    
    
}
