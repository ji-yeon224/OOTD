//
//  OOTDCollectionViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class OOTDCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "OOTDCollectionViewCell"
    
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
        
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        topViewConstraints()
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        bottomConstraints()
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.bottom)
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    private func topViewConstraints() {
        
        //profileImage, nicknameLabel
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalTo(topView)
            make.leading.equalTo(topView).inset(14)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(topView)
            make.leading.equalTo(profileImage.snp.trailing).offset(14)
            make.trailing.equalTo(topView)
            make.verticalEdges.equalTo(topView)
            
        }
        
    }
    
    private func bottomConstraints() {
        
        // likeButton, commentButton
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.leading.equalTo(bottomView).inset(14)
            make.size.equalTo(30)
        }
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.leading.equalTo(likeButton.snp.trailing).offset(14)
            make.size.equalTo(30)
        }
        
        
    }
    
    
}
