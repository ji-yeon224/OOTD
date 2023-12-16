//
//  OOTDView.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxDataSources

final class OOTDView: BaseView {
    
    private let deviceWidth = UIScreen.main.bounds.size.width
    
    weak var delegate: OOTDCellProtocol?
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        view.register(OOTDCollectionViewCell.self, forCellWithReuseIdentifier: OOTDCollectionViewCell.identifier)
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
    
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostListModel> { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OOTDCollectionViewCell.identifier, for: indexPath) as? OOTDCollectionViewCell else { return UICollectionViewCell()}
        
        if let img = item.creator.profile {
            cell.profileImage.setImage(with: img, resize: 30)
        } else {
            cell.profileImage.image = Constants.Image.person
        }
        
        cell.nicknameLabel.text = item.creator.nick
        
        cell.imageView.setImage(with: item.image[0], resize: self.deviceWidth )
        cell.contentLabel.text = item.content
        
        if item.creator.id == UserDefaultsHelper.userID {
            cell.menuButton.isHidden = false
            cell.menuButton.menu = self.setMenuItem(item: item, idx: indexPath.row)
            cell.menuButton.showsMenuAsPrimaryAction = true
        }
        
        return cell
    }
    
    
    
    private func setMenuItem(item: Post, idx: Int) -> UIMenu {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: "Edit") { [weak self] action in
            guard let self = self else { return }
            self.delegate?.editPost(item: item)
        }
        let deleteAction = UIAction(title: "Delete") { [weak self] action in
            guard let self = self else { return }
            self.delegate?.deletePost(id: item.id, idx: idx)
            
        }
        menuItems.append(editAction)
        menuItems.append(deleteAction)
        
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
}



