//
//  CommentWriteView.swift
//  TimeLine
//
//  Created by 김지연 on 12/8/23.
//

import UIKit

final class CommentWriteView: BaseView {
    
    let textView = {
        let view = UITextView()
        view.sizeToFit()
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    let postButton = {
        let view = UIButton()
        view.setImage(Constants.Image.post, for: .normal)
        view.tintColor = Constants.Color.mainColor
        view.backgroundColor = .clear
        return view
    }()
    
    let placeholderLabel = {
        let view = PlainLabel(size: 14, color: Constants.Color.placeholder)
        view.text = "댓글을 입력해주세요."
        return view
    }()
    
    override func configure() {
        backgroundColor = Constants.Color.background
        addSubview(textView)
        addSubview(postButton)
        textView.addSubview(placeholderLabel)
        layer.borderWidth = 0.8
        layer.borderColor = Constants.Color.lightGrayColor.cgColor
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self).inset(10)
            make.height.lessThanOrEqualTo(100)
            make.height.greaterThanOrEqualTo(30)
            make.width.equalTo(self).multipliedBy(0.8)
            
        }
        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(textView).inset(8)
        }
        postButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self).inset(10)
            make.top.greaterThanOrEqualTo(self.snp.top).offset(10)
            make.leading.equalTo(textView.snp.trailing).offset(10)
            make.height.equalTo(postButton.snp.width)
        }
    }
    
    
}
