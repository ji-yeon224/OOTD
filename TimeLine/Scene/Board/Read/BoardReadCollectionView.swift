//
//  BoardReadCollectionView.swift
//  TimeLine
//
//  Created by 김지연 on 12/5/23.
//

import UIKit

final class BoardReadCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
}
