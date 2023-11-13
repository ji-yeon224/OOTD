//
//  ValidCheckLabel.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

final class ValidCheckLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        textColor = Constants.Color.validText
        backgroundColor = Constants.Color.background
        font = .systemFont(ofSize: 13)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
