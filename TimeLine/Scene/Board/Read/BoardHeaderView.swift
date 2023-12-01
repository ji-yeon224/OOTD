//
//  BoardHeaderView.swift
//  TimeLine
//
//  Created by 김지연 on 12/1/23.
//

import UIKit
import SnapKit

final class BoardHeaderView: UICollectionReusableView {
    
    static let identifier = "BoardHeaderView"
    
    let titleLabel = PlainLabel(size: 18, color: Constants.Color.basicText, weight: .bold, line: 0)
    
    let contentLabel = PlainLabel(size: 16, color: Constants.Color.basicText, line: 0)
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        
        //view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    lazy var img1 = PlainImageView(frame: .zero)
    lazy var img2 = PlainImageView(frame: .zero)
    lazy var img3 = PlainImageView(frame: .zero)
    lazy var imgList = [img1, img2, img3]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(img1)
        stackView.addArrangedSubview(img2)
        stackView.addArrangedSubview(img3)
        
    }
    
    private func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
        img1.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        img2.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        img3.snp.makeConstraints { make in
            make.width.equalTo(stackView)
        }
        
    }
    
}
