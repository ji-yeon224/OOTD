//
//  BoardReadView.swift
//  TimeLine
//
//  Created by 김지연 on 12/5/23.
//

import UIKit

final class BoardReadView: BaseView {
    
    var postData: Post?
    var imageURL: [String] = []
    let scrollView = UIScrollView()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    private let infoView = UIView()
    let profileImage = {
        let view = UIImageView()
        view.image = Constants.Image.person
        view.tintColor = Constants.Color.placeholder
        view.clipsToBounds = true
        return view
    }()
    
    let nickname = PlainLabel(size: 14, color: Constants.Color.basicText, line: 1)
    
    private let titleView = UIView()
    private let contentView = UIView()
    
    let titleLabel = PlainLabel(size: 18, color: Constants.Color.basicText, weight: .bold, line: 0)
    
    let contentLabel = PlainLabel(size: 16, color: Constants.Color.basicText, line: 0)
    
    private let emptyView = UIView()
    
    private let bottomView = UIView()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(Constants.Image.heart, for: .normal)
        view.tintColor = .red
        return view
    }()
    
    lazy var img1 = PlainImageView(frame: .zero)
    lazy var img2 = PlainImageView(frame: .zero)
    lazy var img3 = PlainImageView(frame: .zero)
    lazy var imgList = [img1, img2, img3]
    
    
    lazy var collectionView = {
        let view = BoardReadCollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        view.isScrollEnabled = false
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, CommentModel>!
    
    
    override func configure() {
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(contentView)
        
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(img1)
        stackView.addArrangedSubview(img2)
        stackView.addArrangedSubview(img3)
        
        stackView.addArrangedSubview(bottomView)
        
        stackView.addArrangedSubview(collectionView)
        
        stackViewSubViews()
        configureDataSource()
    }
    
    private func stackViewSubViews() {
        infoView.addSubview(profileImage)
        infoView.addSubview(nickname)
        
        titleView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        bottomView.addSubview(likeButton)
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            
        }
        
        infoView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(50)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(10)
            make.verticalEdges.equalTo(infoView).inset(8)
            make.width.equalTo(profileImage.snp.height)
            
        }
        
        nickname.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalTo(infoView)
            make.height.equalTo(20)
        }
        
        titleView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(titleView)
            make.leading.equalTo(titleView).offset(10)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.verticalEdges.equalTo(contentView)
            
        }
        
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(30)
        }
        
        img1.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        img2.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        img3.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(30)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomView).offset(-10)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView)
            
        }
        
    }
    
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let size = UIScreen.main.bounds.width - 40 //self.frame.width - 40
        layout.itemSize = CGSize(width: size, height: size / 4)
        return layout
    }
    
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BoardCommentCell, CommentModel> { cell, indexPath, itemIdentifier in
            
            cell.label.text = itemIdentifier.comment
            
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            
            return cell
            
        })
        

        
        
        
    }
    
    
}
