//
//  MyPageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation

final class MyPageView: BaseView {
    
    let profileView = ProfileView()
    
    override func configure() {
        addSubview(profileView)
    }
    
    override func setConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(14)
        }
    }
    
}
