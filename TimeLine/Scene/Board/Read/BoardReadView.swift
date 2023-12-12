//
//  BoardReadView.swift
//  TimeLine
//
//  Created by 김지연 on 12/5/23.
//

import UIKit

final class BoardReadView: BaseView {
    
    
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
    let date = PlainLabel(size: 14, color: Constants.Color.placeholder, line: 1)
    
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
    
    private let imageBackView1 = UIView()
    private let imageBackView2 = UIView()
    private let imageBackView3 = UIView()
    
    lazy var img1 = PlainImageView(frame: .zero)
    lazy var img2 = PlainImageView(frame: .zero)
    lazy var img3 = PlainImageView(frame: .zero)
    lazy var imgList = [img1, img2, img3]
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.lightGrayColor
        return view
    }()
    
    private let commentView = UIView()
    let commentLabel = PlainLabel(size: 17, color: Constants.Color.subText)
    
    let commentWriteView = CommentWriteView()
    
    
    lazy var tableView = {
        let view = BoardTableView()
        view.isScrollEnabled = false
        view.rowHeight = UITableView.automaticDimension
        view.register(BoardCommentCell.self, forCellReuseIdentifier: BoardCommentCell.identifier)
        view.separatorStyle = .none
        return view
        
    }()
    
    
    var dataSource: UITableViewDiffableDataSource<Int, Comment>!
    
    
    override func configure() {
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(contentView)
        
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(imageBackView1)
        stackView.addArrangedSubview(imageBackView2)
        stackView.addArrangedSubview(imageBackView3)
        
        stackView.addArrangedSubview(bottomView)
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(commentView)
        stackView.addArrangedSubview(tableView)
        addSubview(commentWriteView)
        
        stackViewSubViews()
        
        scrollView.keyboardDismissMode = .onDrag
                
        
    }
    
    
    private func stackViewSubViews() {
        infoView.addSubview(profileImage)
        infoView.addSubview(nickname)
        infoView.addSubview(date)
        
        titleView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        bottomView.addSubview(likeButton)
        
        imageBackView1.addSubview(img1)
        imageBackView2.addSubview(img2)
        imageBackView3.addSubview(img3)
        
        commentView.addSubview(commentLabel)
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            
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
//            make.centerY.equalTo(infoView)
            make.top.equalTo(infoView).inset(4)
            make.height.equalTo(infoView.snp.height).multipliedBy(0.5)
        }
        date.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(infoView.snp.height).multipliedBy(0.5)
            make.bottom.equalTo(infoView).inset(4)
            
        }
        
        titleView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(titleView).inset(15)
        }
        
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(15)
            
        }
        
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(30)
        }
        
        imageBackView1.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        img1.snp.makeConstraints { make in
            make.edges.equalTo(imageBackView1).inset(5)
        }
        imageBackView2.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        img2.snp.makeConstraints { make in
            make.edges.equalTo(imageBackView2).inset(5)
        }
        imageBackView3.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
        }
        img3.snp.makeConstraints { make in
            make.edges.equalTo(imageBackView3).inset(5)
        }
        
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(30)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomView).offset(-15)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(5)
        }
        commentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView)
            make.height.equalTo(30)
        }
        commentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(commentView).inset(20)
            make.centerY.equalTo(commentView)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView)
            
        }
        
        commentWriteView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let size = UIScreen.main.bounds.width - 10 //self.frame.width - 40
        layout.itemSize = CGSize(width: size, height: size / 4)
        return layout
    }
    
    func setLikeButton(like: Bool) {
        let img = like ? Constants.Image.heartFill : Constants.Image.heart
        likeButton.setImage(img, for: .normal)
    }
    

    
    
}
