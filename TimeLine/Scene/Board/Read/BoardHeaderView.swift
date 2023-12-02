//
//  BoardHeaderView.swift
//  TimeLine
//
//  Created by 김지연 on 12/1/23.
//

import UIKit
import SnapKit

final class BoardHeaderView: UICollectionReusableView {
    
    static let identifier = "BoardHeaderView"
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        
        //view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let infoView = UIView()
    let profileImage = {
        let view = UIImageView()
        view.image = Constants.Image.person
//        view.backgroundColor = Constants.Color.placeholder
        view.tintColor = Constants.Color.placeholder
        view.clipsToBounds = true
        return view
    }()
    
    let nickname = PlainLabel(size: 14, color: Constants.Color.basicText, line: 1)
    
    let titleLabel = PlainLabel(size: 18, color: Constants.Color.basicText, weight: .bold, line: 0)
    
    let contentLabel = PlainLabel(size: 16, color: Constants.Color.basicText, line: 0)
    
    private let emptyView = UIView()
    
    private let bottomView = UIView()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(Constants.Image.heart, for: .normal)
        view.tintColor = .red
        return view
    }()
    
    private let commentLabel = {
        let view = PlainLabel(size: 14, color:  Constants.Color.subText)
        view.text = "Comment"
        return view
    }()
    
    lazy var img1 = PlainImageView(frame: .zero)
    lazy var img2 = PlainImageView(frame: .zero)
    lazy var img3 = PlainImageView(frame: .zero)
    lazy var imgList = [img1, img2, img3]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    private func configure() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(infoView)
        infoView.addSubview(profileImage)
        infoView.addSubview(nickname)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(img1)
        stackView.addArrangedSubview(img2)
        stackView.addArrangedSubview(img3)
        stackView.addArrangedSubview(bottomView)
        bottomView.addSubview(likeButton)
        stackView.addArrangedSubview(commentLabel)
    }
    
    private func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        infoView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(50)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(10)
            make.verticalEdges.equalTo(infoView).inset(8)
            make.width.equalTo(profileImage.snp.height)
            
        }
        
        nickname.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalTo(infoView)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(30)
        }
        
        img1.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        img2.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        img3.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(30)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomView).offset(-10)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(20)
        }
        commentLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(16)
        }
        
    }
    
}
