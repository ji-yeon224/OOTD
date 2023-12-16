//
//  ValidStackView.swift
//  TimeLine
//
//  Created by 김지연 on 11/18/23.
//

import UIKit

final class ValidStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fill
        spacing = 5
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
