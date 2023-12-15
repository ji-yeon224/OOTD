//
//  OOTDCollectionViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class OOTDCollectionViewCell: BaseCollectionViewCell {
    
    
    private let topView = UIView()
    let profileImage = ProfileImageView(frame: .zero)
    let nicknameLabel = PlainLabel(size: 13, color: Constants.Color.basicText, line: 1)
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let bottomView = UIView()
    let likeButton = {
        let view = UIButton()
        view.setImage(Constants.Image.heart, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.backgroundColor = Constants.Color.background
        return view
    }()
    let commentButton = {
        let view = UIButton()
        view.setImage(Constants.Image.comment, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.backgroundColor = Constants.Color.background
        return view
    }()
    
    let contentLabel = PlainLabel(size: 14, color: Constants.Color.basicText, line: 0)
    
    
    
    override func configure() {
        
        [topView, imageView, bottomView, contentLabel].forEach {
            contentView.addSubview($0)
        }
        
        [profileImage, nicknameLabel].forEach {
            topView.addSubview($0)
        }
        
        [likeButton, commentButton].forEach {
            bottomView.addSubview($0)
        }
        
        
        
    }
    
    override func setConstraints() {
        
        
        
    }
    
    private func topViewConstraints() {
        
        
    }
    
    private func bottomConstraints() {
        
    }
    
    
}
