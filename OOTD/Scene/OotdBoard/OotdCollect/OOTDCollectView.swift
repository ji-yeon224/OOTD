//
//  OOTDCollectView.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import UIKit
import RxDataSources

final class OOTDCollectView: BaseView {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        view.register(OOTDCollectCell.self, forCellWithReuseIdentifier: OOTDCollectCell.identifier)
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostListModel> { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OOTDCollectCell.identifier, for: indexPath) as? OOTDCollectCell else { return UICollectionViewCell() }
        
        if item.image.count > 0 {
            cell.imageView.setImage(with: item.image[0], resize:  UIScreen.main.bounds.size.width / 3)
        }
        
        return cell
        
    }
    
    
    private func configureCollectionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(1) // 아이템 옆 간격
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1 // 줄 간격
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    
}
