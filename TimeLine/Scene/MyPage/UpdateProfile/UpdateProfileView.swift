//
//  UpdateProfileView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class UpdateProfileView: BaseView {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = Constants.Image.person
        view.tintColor = Constants.Color.placeholder
        view.backgroundColor = Constants.Color.background
        
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func configure() {
        
    }
    
    override func setConstraints() {
        
    }
    
}
