//
//  PlainIamgeView.swift
//  TimeLine
//
//  Created by 김지연 on 11/29/23.
//

import UIKit

final class PlainImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
