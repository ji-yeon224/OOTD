//
//  BoardCommentCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/1/23.
//

import UIKit
import RxSwift
final class BoardCommentCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    private let backView = UIView()
    let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: .zero, right: 10)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let profileView = UIView()
    let profileImage = ProfileImageView(frame: .zero)
    
    let nicknameLabel = PlainLabel(size: 13, color: Constants.Color.basicText, line: 1)
    let contentLabel = PlainLabel(size: 14, color: Constants.Color.basicText, line: 0)
    let dateLabel = PlainLabel(size: 12, color: Constants.Color.subText, line: 1)
    let deleteButton = {
        let view = UIButton()
        view.setImage(Constants.Image.delete, for: .normal)
        view.tintColor = Constants.Color.placeholder
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.isHidden = true
        disposeBag = DisposeBag()
    }
    
    override func configure() {
        
        contentView.addSubview(backView)
        backView.addSubview(stackView)
        [profileView, contentLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        [profileImage, nicknameLabel, deleteButton].forEach {
            profileView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(10)
        }
        profileView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileView.snp.leading)
            make.size.equalTo(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
            make.height.equalTo(20)
        
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.trailing.equalTo(profileView.snp.trailing).offset(-10)
            make.size.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    
}

struct CommentModel: Hashable {
    let id = UUID()
    var comment: String
}



