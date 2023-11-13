//
//  TextFieldUnderline.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

final class TextFieldUnderline: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.mainColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
