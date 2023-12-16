//
//  MainButton.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

final class MainButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(Constants.Color.tint, for: .normal)
        titleLabel?.font = .systemFont(ofSize: Constants.Design.defaultFontSize)
        backgroundColor = Constants.Color.mainColor
        
        layer.cornerRadius = Constants.Design.buttonRadius
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
