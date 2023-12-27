//
//  DetailPhotoViewController.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailPhotoViewController: BaseViewController {
    
    private let mainView = OOTDView()//DetailPhotoView()
    private let viewModel = OOTDViewModel()
    private let disposeBag = DisposeBag()
    var post: Post?
    
    
    override func loadView() {
//        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
//        bind()
//        configData()
    }
    
    private func bind() {
        guard let post = post else {
            showOKAlert(title: "", message: "데이터를 불러올 수 없습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        Observable.just([PostListModel(section: "", items: [post])])
            .bind(to: mainView.collectionView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
        
    }
    
//    private func configData() {
//        guard let post = post else {
//            showOKAlert(title: "", message: "데이터를 불러올 수 없습니다.") {
//                self.navigationController?.popViewController(animated: true)
//            }
//            return
//        }
//        var likeValue: Bool = false
//        if post.image.count > 0 {
//            mainView.imageView.setImage(with: post.image[0], resize: Constants.Design.deviceWidth, cornerRadius: 0)
//            
//        }
//        
//        if let img = post.creator.profile {
//            mainView.profileImage.setImage(with: img, resize: 30)
//        } else {
//            mainView.profileImage.image = Constants.Image.placeholderProfile
//        }
//        mainView.nicknameLabel.text = post.creator.nick
//        mainView.contentLabel.text = post.content
//        if post.creator.id == UserDefaultsHelper.userID {
//            mainView.menuButton.isHidden = false
//            mainView.menuButton.menu
//        }
//        
//        
//        
//    }
    
//    private func setMenuItem(item: Post, idx: Int) -> UIMenu {
//        var menuItems: [UIAction] = []
//        
//        let editAction = UIAction(title: "Edit") { [weak self] action in
//            guard let self = self else { return }
//            self.delegate?.editPost(item: item)
//        }
//        let deleteAction = UIAction(title: "Delete") { [weak self] action in
//            guard let self = self else { return }
//            self.delegate?.deletePost(id: item.id, idx: idx)
//            
//        }
//        menuItems.append(editAction)
//        menuItems.append(deleteAction)
//        
//        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
//    }
    
}
