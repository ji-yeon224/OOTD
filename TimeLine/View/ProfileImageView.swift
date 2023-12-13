//
//  CircleImageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class ProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = Constants.Image.person
        tintColor = Constants.Color.placeholder
        backgroundColor = Constants.Color.background
        contentMode = .scaleAspectFill
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        layer.borderWidth = 0.8
        layer.borderColor = Constants.Color.lightGrayColor.cgColor
    }
    
    
    
    
}
