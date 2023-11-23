//
//  BoardView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import Kingfisher

final class BoardView: BaseView {
    
    var titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = Constants.Color.basicText
        return view
    }()
    
    var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
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
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(writeButton)
        
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(200)
            
        }
        
        writeButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
}
