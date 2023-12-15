//
//  BoardTableViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import UIKit
import SnapKit

final class BoardTableViewCell: UITableViewCell {
    
    
    let titleLabel = PlainLabel(size: 16, color: Constants.Color.basicText, line: 2)
    let contentLabel = PlainLabel(size: 13, color: Constants.Color.subText)
    
    let createrLabel = PlainLabel(size: 13, color: Constants.Color.subText)
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
    
    private let commentView = UIView()
    private let likeView = UIView()
    
    private let commentImg = {
        let view = UIImageView()
        view.image = Constants.Image.comment
        view.tintColor = Constants.Color.basicText
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let likeImg = {
        let view = UIImageView()
        view.image = Constants.Image.heart
        view.tintColor = Constants.Color.basicText
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let commentLabel = PlainLabel(size: 13, color: Constants.Color.subText)
    private let likeLabel = PlainLabel(size: 13, color: Constants.Color.subText)
    
    
    let thumbnailImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Constants.Color.lightGrayColor.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var textStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 8
        
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(contentLabel)
        view.addArrangedSubview(createrLabel)
        view.addArrangedSubview(reactView)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        createrLabel.text = nil
        thumbnailImage.isHidden = false
        thumbnailImage.image = nil
        commentView.isHidden = false
        likeView.isHidden = false
    }
    
    private func configure() {
        contentView.addSubview(textStackView)
        contentView.addSubview(thumbnailImage)
        
        
        
        reactView.addSubview(reactStackView)
        commentView.addSubview(commentImg)
        commentView.addSubview(commentLabel)
        likeView.addSubview(likeImg)
        likeView.addSubview(likeLabel)
        
    }
    
    private func setConstraints() {
        
        thumbnailImage.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.top.trailing.equalTo(contentView).inset(18)
            
        }
        textStackView.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).inset(18)
            make.trailing.greaterThanOrEqualTo(thumbnailImage.snp.leading).offset(-12)
            make.trailing.lessThanOrEqualTo(contentView).offset(-18)
            make.bottom.equalTo(contentView).offset(-12)
        }
        
        createrLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        
        reactView.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        reactStackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(reactView)
        }
        
        commentView.snp.makeConstraints { make in
            make.height.equalTo(15)
            
        }
        likeView.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textStackView)
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
    
    func setReactLabel(comment: Int, heart: Int) {
        if comment == 0 {
            commentView.isHidden = true
        }
        if heart == 0 {
            likeView.isHidden = true
        }
        
        commentLabel.text = "\(comment)"
        likeLabel.text = "\(heart)"
    }
    
   

}
