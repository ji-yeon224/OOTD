//
//  CustomTextField.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

final class CustomTextField: UITextField {
    
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
