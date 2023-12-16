//
//  BoardContentSection.swift
//  TimeLine
//
//  Created by 김지연 on 11/30/23.
//

import UIKit

struct BoardContentSection: Identifiable, Hashable {
    
    var id = UUID()
    var title: String?
    var content: String?
    var image: UIImage?
    
}
