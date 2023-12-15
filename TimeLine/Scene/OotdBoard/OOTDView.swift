//
//  OOTDView.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxDataSources

final class OOTDView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
    
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(10) // 아이템 옆 간격
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        //section.interGroupSpacing = 10 // 줄 간격
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
    
}
