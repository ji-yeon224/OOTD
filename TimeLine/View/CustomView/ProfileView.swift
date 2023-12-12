//
//  ProfileView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class ProfileView: BaseView {
    
//    private let backView = UIView()
    lazy var profileImageView = {
        let view = UIImageView()
        view.image = Constants.Image.person
        view.tintColor = Constants.Color.placeholder
        view.backgroundColor = Constants.Color.background
        
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nicknameLabel = PlainLabel(size: 16, color: Constants.Color.basicText, line: 1)
    
    
    let editButton = {
        let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.setTitleColor(Constants.Color.basicText, for: .normal)
        view.backgroundColor = Constants.Color.lightGrayColor
//        view.layer.borderWidth = 1
//        view.layer.borderColor = Constants.Color.lightGrayColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    override func configure() {
        [profileImageView, nicknameLabel, editButton].forEach {
            addSubview($0)
        }
        nicknameLabel.text = "nickname"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 0.8
        profileImageView.layer.borderColor = Constants.Color.lightGrayColor.cgColor
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
            make.size.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(self)
            
        }
    }
    
    
    
}
