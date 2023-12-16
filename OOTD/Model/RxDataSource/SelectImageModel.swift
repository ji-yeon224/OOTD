//
//  SelectImageModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/27/23.
//

import UIKit
import RxDataSources

struct SelectImageModel: SectionModelType {
    typealias Item = SelectedImage
    var section: String
    var items: [SelectedImage]
}

extension SelectImageModel {
    init(original: SelectImageModel, items: [SelectedImage]) {
        self = original
        self.items = items
    }
}
