//
//  BoardCollectionView.swift
//  TimeLine
//
//  Created by 김지연 on 11/30/23.
//

import UIKit


final class BoardCollectionView: BaseView {
    
    var postData: Post?
    var imageList: [UIImage] = []
    var imageURL: [String] = []
    let deviceWidth = UIScreen.main.bounds.size.width
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.configureCollectionLayout())

        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, CommentModel>!
    let dispatchGroup = DispatchGroup()
    
    override func configure() {
        addSubview(collectionView)
        configureDataSource()
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func configureCollectionLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.interItemSpacing = .fixed(10) // 아이템 옆 간격
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200)),
            elementKind: BoardHeaderView.identifier,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        //section.interGroupSpacing = 10 // 줄 간격
        let layout = UICollectionViewCompositionalLayout(section: section)
        
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
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<BoardHeaderView>(elementKind: BoardHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let post = self.postData else { return }
            supplementaryView.titleLabel.text = post.title
            supplementaryView.contentLabel.text = post.content
            supplementaryView.nickname.text = post.creator.nick
            
            
            DispatchQueue.main.async {
                self.dispatchGroup.enter()
                for i in 0..<self.imageURL.count {
                    supplementaryView.imgList[i].setImage(with: self.imageURL[i], resize: self.deviceWidth-30)
                    
                }
//                print("img")
//                supplementaryView.layoutIfNeeded()
                self.dispatchGroup.leave()
//                NotificationCenter.default.post(name: .reloadHeader, object: nil)
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {

                NotificationCenter.default.post(name: .reloadHeader, object: nil)
            }
            
        }
        
        
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }

        
        
        
    }
    
}


