//
//  BoardTableViewCell.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import UIKit
import SnapKit

final class BoardTableViewCell: UITableViewCell {
    
    static let identifier = "BoardTableViewCell"
    
    let titleLabel = PlainLabel(size: 20, color: Constants.Color.basicText, line: 2)
    let contentLabel = PlainLabel(size: 15, color: Constants.Color.subText)
    
    let createrLabel = PlainLabel(size: 15, color: Constants.Color.subText)
    
    let thumbnailImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var textStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 8
        
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(contentLabel)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        createrLabel.text = nil
        thumbnailImage.isHidden = false
        thumbnailImage.image = nil
    }
    
    private func configure() {
        contentView.addSubview(textStackView)
        contentView.addSubview(thumbnailImage)
        
        contentView.addSubview(createrLabel)
        
    }
    
    private func setConstraints() {
        
        thumbnailImage.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.top.trailing.equalTo(contentView).inset(18)
            
        }
        textStackView.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).inset(18)
            make.trailing.equalTo(thumbnailImage.snp.leading).offset(-12)
            make.bottom.equalTo(createrLabel.snp.top).offset(-12)
        }
        createrLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(contentView).inset(18)
            make.height.equalTo(15)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textStackView)
        }
        
    }
    
   

}
