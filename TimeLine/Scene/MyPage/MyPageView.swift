//
//  MyPageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class MyPageView: BaseView {
    
    private let titleLabel = PlainLabel(size: 30, color: Constants.Color.basicText, weight: .bold)
    
    var profileView = ProfileView()
    
    override func configure() {
        addSubview(titleLabel)
        addSubview(profileView)
        titleLabel.text = "MyPage"
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(14)
            make.height.equalTo(150)
        }
    }
    
    func setInfo(nick: String, profile: String?) {
        
        profileView.nicknameLabel.text = nick
        if let profile = profile {
            profileView.profileImageView.setImage(with: profile, resize: 100)
        } else {
            profileView.profileImageView.image = Constants.Image.person
        }
        
    }
    
    
}
