//
//  OOTDView.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxDataSources

final class OOTDView: BaseView {
    
    private static let deviceWidth = UIScreen.main.bounds.size.width
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        view.register(OOTDCollectionViewCell.self, forCellWithReuseIdentifier: OOTDCollectionViewCell.id)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.interItemSpacing = .fixed(10) // 아이템 옆 간격
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
//        section.orthogonalScrollingBehavior = .paging
        section.interGroupSpacing = 10 // 줄 간격
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<PostListModel> { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OOTDCollectionViewCell.id, for: indexPath) as? OOTDCollectionViewCell else { return UICollectionViewCell()}
        
        if let img = item.creator.profile {
            cell.profileImage.setImage(with: img, resize: 30)
        } else {
            cell.profileImage.image = Constants.Image.person
        }
        
        cell.nicknameLabel.text = item.creator.nick
//        cell.imageView.image = UIImage(named: "img2")?.resize(width: deviceWidth)
        cell.imageView.setImage(with: item.image[0], resize: deviceWidth )
        cell.contentLabel.text = item.content
        cell.layoutIfNeeded()
        
        return cell
    }
    
}



