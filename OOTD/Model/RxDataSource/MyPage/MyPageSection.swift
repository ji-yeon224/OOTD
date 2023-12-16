//
//  MyPageSection.swift
//  TimeLine
//
//  Created by 김지연 on 12/14/23.
//

import Foundation
import RxDataSources

struct MyPageSection: SectionModelType {
    typealias Item = MyPageContent
    
    var section: String
    var items: [Item]
}

extension MyPageSection {
    init(original: MyPageSection, items: [MyPageContent]) {
        self = original
        self.items = items
    }
}
