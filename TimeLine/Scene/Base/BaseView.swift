//
//  BaseView.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { backgroundColor = Constants.Color.background }
    func setConstraints() { }
    
}

