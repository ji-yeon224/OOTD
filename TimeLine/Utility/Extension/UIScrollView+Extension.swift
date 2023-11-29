//
//  UIScrollView+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import UIKit

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
