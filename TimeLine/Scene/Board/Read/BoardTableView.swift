//
//  BoardTableViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/8/23.
//

import UIKit

final class BoardTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
}
