//
//  OOTDCollectionViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift

final class OOTDCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        return view
        
    }()
    
    private let topView = UIView()
    let profileImage = ProfileImageView(frame: .zero)
    let nicknameLabel = PlainLabel(size: 13, color: Constants.Color.basicText, line: 1)
    let menuButton = {
        let view = UIButton()
        view.setImage(Constants.Image.menuButton, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.isHidden = true
        return view
    }()
    
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
    
    private let contentBackView = UIView()
    let contentLabel = PlainLabel(size: 14, color: Constants.Color.basicText, line: 0)
    
    private let dateView = UIView()
    let dateLabel = PlainLabel(size: 12, color: Constants.Color.subText)
    
    override func prepareForReuse() {
        menuButton.isHidden = true
        
//        likeButton.setImage(Constants.Image.heart, for: .normal)
//        likeButton.setTitleColor(Constants.Color.basicText, for: .normal)
        disposeBag = DisposeBag()
    }
    
    override func configure() {
        
        contentView.addSubview(stackView)
        
        [topView, imageView, bottomView, contentBackView, dateView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [profileImage, nicknameLabel, menuButton].forEach {
            topView.addSubview($0)
        }
        
        [likeButton, commentButton].forEach {
            bottomView.addSubview($0)
        }
        
        contentBackView.addSubview(contentLabel)
        dateView.addSubview(dateLabel)
        
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        topView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        topViewConstraints()
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
//            make.horizontalEdges.equalTo(contentView)
//            make.top.equalTo(topView.snp.bottom)
//            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        bottomConstraints()
        
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentBackView)
            make.horizontalEdges.equalTo(contentBackView).inset(14)
//            make.bottom.equalTo(contentView)
        }
        dateView.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(dateView).inset(5)
            make.horizontalEdges.equalTo(dateView).inset(14)
            
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
            make.trailing.equalTo(menuButton.snp.leading)
            make.verticalEdges.equalTo(topView)
            
        }
        
        menuButton.snp.makeConstraints { make in
            make.centerY.equalTo(topView)
            make.trailing.equalTo(topView).inset(5)
            make.size.equalTo(40)
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
