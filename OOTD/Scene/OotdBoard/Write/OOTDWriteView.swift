//
//  OOTDWriteView.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class OOTDWriteView: BaseView {
    
    private let imageBackView = UIView()
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    lazy var contentTextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.font = .systemFont(ofSize: 15)
        view.textColor = Constants.Color.basicText
        view.backgroundColor = Constants.Color.background
        return view
    }()
    
    let placeHolderLabel = {
        let view = PlainLabel(size: 15, color: Constants.Color.placeholder)
        view.text = "오늘의 옷 정보를 공유해주세요!"
        view.textAlignment = .left
        return view
    }()
    
    override func configure() {
        super.configure()
        
        [imageBackView, contentTextView].forEach {
            addSubview($0)
        }
        
        imageBackView.addSubview(imageView)
        contentTextView.addSubview(placeHolderLabel)
        
    }
    
    override func setConstraints() {
        
        imageBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageBackView).offset(14)
            make.centerX.equalTo(imageBackView)
            make.bottom.equalTo(imageBackView).offset(-14)
            make.horizontalEdges.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(14)
            
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageBackView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(10)

        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView).offset(10)
            make.leading.equalTo(contentTextView).offset(21)
            make.width.equalTo(contentTextView)
            make.height.equalTo(30)
        }
        
    }
    
    
    
    
}
