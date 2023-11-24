//
//  PostListModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import Foundation
import RxDataSources

struct PostListModel: SectionModelType {
    typealias Item = Post
    
    
    var section: String
    var items: [Item]
}

extension PostListModel {
    init(original: PostListModel, items: [Item]) {
        self = original
        self.items = items
    }
}
