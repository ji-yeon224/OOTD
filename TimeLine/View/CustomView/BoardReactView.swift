//
//  BoardReactView.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class BoardReactView: BaseView {
    
    private let reactView = UIView()
    private lazy var reactStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.spacing = 5
        view.addArrangedSubview(commentView)
        view.addArrangedSubview(likeView)
        return view
    }()
    
    let commentView = UIView()
    let likeView = UIView()
    
    private let commentImg = {
        let view = UIImageView()
        view.image = Constants.Image.comment
        view.tintColor = Constants.Color.subText
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let likeImg = {
        let view = UIImageView()
        view.image = Constants.Image.heart
        view.tintColor = Constants.Color.subText
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let commentLabel = PlainLabel(size: 13, color: Constants.Color.subText)
    private let likeLabel = PlainLabel(size: 13, color: Constants.Color.subText)
    
    
    override func configure() {
        
        addSubview(reactStackView)
        commentView.addSubview(commentImg)
        commentView.addSubview(commentLabel)
        likeView.addSubview(likeImg)
        likeView.addSubview(likeLabel)
        
    }
    
    override func setConstraints() {
        reactStackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self)
        }
        
        commentView.snp.makeConstraints { make in
            make.height.equalTo(15)
            
        }
        likeView.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        
        
        
        
        
        commentImg.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(commentView)
            make.size.equalTo(15)
        }
        commentLabel.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(commentView)
            make.leading.equalTo(commentImg.snp.trailing).offset(4)
        }
        
        likeImg.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(likeView)
            make.size.equalTo(15)
        }
        likeLabel.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(likeView)
            make.leading.equalTo(likeImg.snp.trailing).offset(4)
        }
    
    }
    
    func setLabel(_ comment: Int, _ heart: Int) {
        commentLabel.text = "\(comment)"
        likeLabel.text = "\(heart)"
    }
    
    
}

