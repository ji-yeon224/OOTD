//
//  PlainLabel.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import UIKit

final class PlainLabel: UILabel {
    
    init(size: CGFloat, color: UIColor, weight: UIFont.Weight = .regular, line: Int = 1) {
        super.init(frame: .zero)
        
        font = .systemFont(ofSize: size, weight: weight)
        numberOfLines = line
        textColor = color
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
