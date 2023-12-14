//
//  MyPageView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxDataSources

final class MyPageView: BaseView {
    
    private let titleLabel = PlainLabel(size: 30, color: Constants.Color.basicText, weight: .bold)
    
    var profileView = ProfileView()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<String, MyPageContent>!
    
    override func configure() {
        addSubview(titleLabel)
        addSubview(profileView)
        addSubview(collectionView)
        titleLabel.text = "MyPage"
        
        configureDataSource()
        updateSnapShot()
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
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
        
        // UICollectionView.CellRegistration iOS 14, 메서드 대신 제네릭 사용, 셀이 생성될 때 마다 클로저가 호출
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
            
        }
        
        //CellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        
    }
    
    func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, MyPageContent>()
        snapshot.appendSections(["내 활동", "계정"])
        snapshot.appendItems(myActivity, toSection: "내 활동")
        snapshot.appendItems(account, toSection: "계정")
        dataSource.apply(snapshot)
    }
    
    
    func setInfo(nick: String, profile: String?) {
        
        profileView.nicknameLabel.text = nick
        if let profile = profile {
            profileView.profileImageView.setImage(with: profile, resize: 100)
        } else {
            profileView.profileImageView.image = Constants.Image.person
        }
        
    }
    
    
}
