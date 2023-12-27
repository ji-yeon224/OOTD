//
//  AccountSettingView.swift
//  OOTD
//
//  Created by 김지연 on 12/21/23.
//

import UIKit

final class AccountSettingView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, MyPageContent>!
    var dataSource: UICollectionViewDiffableDataSource<String, MyPageContent>!
    
    
    
    override func configure() {
        super.configure()
        addSubview(collectionView)
        collectionView.isScrollEnabled = false
        configDataSource()
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(20)
        }
    }
    
    
    
    func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    func configDataSource() {
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.font = .systemFont(ofSize: 16)
            content.textProperties.color = itemIdentifier.textColor
            content.textProperties.alignment = .center
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = Constants.Color.background
            
            cell.backgroundConfiguration = backgroundConfig
            
        })
        
        dataSource = UICollectionViewDiffableDataSource<String, MyPageContent>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
}
