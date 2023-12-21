//
//  MyPageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxDataSources

final class MyPageView: BaseView {
    
    private let topView = UIView()
    
    private let titleLabel = PlainLabel(size: 30, color: Constants.Color.basicText, weight: .bold)
    var menuButton = {
        let view = UIButton()
        view.setImage(Constants.Image.menuButton, for: .normal)
        view.tintColor = Constants.Color.basicText
        view.backgroundColor = .clear
        return view
    }()
    
    var profileView = ProfileView()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<String, MyPageContent>!
    
    
    
    override func configure() {
        addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(menuButton)
        
        addSubview(profileView)
        addSubview(collectionView)
        titleLabel.text = "MyPage"
        
        configureDataSource()
        updateSnapShot()
        collectionView.isScrollEnabled = false
        
    }
    
    override func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(topView)
            make.leading.equalTo(topView).inset(14)
            make.trailing.equalTo(menuButton.snp.leading).offset(-10)
        }
        
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerY.equalTo(topView)
            make.trailing.equalTo(topView).inset(14)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(14)
            make.height.equalTo(150)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    static private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = false // 셀 경계선
        configuration.backgroundColor = Constants.Color.background
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func configureDataSource() {
        
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MyPageContent> { cell, indexPath, itemIdentifier in
            
            // 셀 디자인 및 데이터 처리
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            if let image = itemIdentifier.img {
                content.image = image
                cell.accessories = [
                    .outlineDisclosure(displayed: .always)
                    
                ]
            }
            
            
            content.textProperties.color = itemIdentifier.textColor
            content.imageProperties.tintColor = Constants.Color.basicText
            
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = Constants.Color.background
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        
        //CellForItemAt
        dataSource = UICollectionViewDiffableDataSource<String, MyPageContent>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, MyPageContent>()
        snapshot.appendSections([""])
        snapshot.appendItems(list)
//        snapshot.appendItems(account, toSection: "계정")
        dataSource.apply(snapshot)
    }
    
    
    func setInfo(nick: String, profile: String?) {
        
        profileView.nicknameLabel.text = nick
        if let profile = profile {
            profileView.profileImageView.setImage(with: profile, resize: 100)
        } else {
            profileView.profileImageView.image = Constants.Image.placeholderProfile
        }
        
    }
    
    
}
