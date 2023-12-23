//
//  MyPageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxDataSources

final class MyPageView: BaseView {
    
    private let topView = UIView()
    var userId: String?
    
    private let titleLabel = PlainLabel(size: 30, color: Constants.Color.basicText, weight: .bold)
    var menuButton = {
        let view = UIButton()
        view.setImage(Constants.Image.menuButton, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.backgroundColor = .clear
        return view
    }()
    
    var profileView = ProfileView()
    
    
    private lazy var vc = MyPageTabViewController(id: self.userId ?? UserDefaultsHelper.userID)
    private var contentView: UIView {
        self.vc.view
    }
    
    override func configure() {
        addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(menuButton)
        
        addSubview(profileView)
        
        titleLabel.text = "MyPage"
        addSubview(contentView)
        
    }
    
    override func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(topView)
            make.leading.equalTo(topView).inset(14)
            make.trailing.equalTo(menuButton.snp.leading).offset(-10)
        }
        
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerY.equalTo(topView)
            make.trailing.equalTo(topView).inset(14)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(14)
            make.height.equalTo(150)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        
    }
    
    func setInfo(nick: String, profile: String?) {
        
        profileView.nicknameLabel.text = nick
        if let profile = profile {
            profileView.profileImageView.setImage(with: profile, resize: 100)
        } else {
            profileView.profileImageView.image = Constants.Image.placeholderProfile
        }
        
    }
    
    
}
