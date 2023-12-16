//
//  ReusableProtocol.swift
//  TimeLine
//
//  Created by 김지연 on 11/29/23.
//

import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
