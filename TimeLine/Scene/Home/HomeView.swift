//
//  HomeView.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit

final class HomeView: BaseView {
    
    let contentButton = MainButton(title: "게시글 작성")
    let withdrawButton = MainButton(title: "탈퇴")
    let logoutButton = MainButton(title: "로그아웃")
    
    override func configure() {
        super.configure()
        addSubview(contentButton)
        addSubview(withdrawButton)
        addSubview(logoutButton)
    }
    
    override func setConstraints() {
        contentButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).offset(100)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(contentButton.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(withdrawButton.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
}
