//
//  OOTDCollectCell.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import UIKit

final class OOTDCollectCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = Constants.Color.background
        view.layer.borderColor = Constants.Color.background.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(imageView)
    }
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
