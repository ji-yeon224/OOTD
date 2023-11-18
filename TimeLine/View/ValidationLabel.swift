//
//  ValidationLabel.swift
//  TimeLine
//
//  Created by 김지연 on 11/18/23.
//

import UIKit

final class ValidationLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        textColor = Constants.Color.invalid
        backgroundColor = Constants.Color.background
        font = .systemFont(ofSize: 15)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
