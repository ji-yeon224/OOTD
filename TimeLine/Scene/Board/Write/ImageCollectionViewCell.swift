//
//  ImageCollectionViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 11/26/23.
//

import UIKit
import SnapKit
import RxSwift

final class ImageCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let uiview = UIView()
    var disposeBag = DisposeBag()
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 5
        return view
    }()
    
    let cancelButton = {
        let view = UIButton()
        view.setImage(Constants.Image.xmarkCircle, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.backgroundColor = Constants.Color.background
        view.layer.opacity = 0.8
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = false
        return view
    }()
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
        disposeBag = DisposeBag()
    }
    
    override func configure() {
        contentView.addSubview(uiview)
        contentView.addSubview(imageView)
        contentView.addSubview(cancelButton)
    }
    
    override func setConstraints() {
        
        uiview.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            
        }
        imageView.snp.makeConstraints { make in
           
            make.top.bottom.equalTo(contentView).inset(5)
            make.horizontalEdges.equalTo(uiview)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.2)
            make.height.equalTo(cancelButton.snp.width)
        }
        
    }
    
    
}
