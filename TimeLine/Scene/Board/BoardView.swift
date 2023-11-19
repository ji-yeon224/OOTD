//
//  BoardView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit

final class BoardView: BaseView {
    
    let writeButton = {
        let view = UIButton()
        view.setImage(Constants.Image.plus, for: .normal)
        view.backgroundColor = Constants.Color.mainColor
        view.tintColor = Constants.Color.background
        view.layer.cornerRadius = view.bounds.width/2
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(writeButton)
    }
    
    override func setConstraints() {
        writeButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
}
