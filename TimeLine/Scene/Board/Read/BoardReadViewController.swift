//
//  BoardReadViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/23/23.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardReadViewController: BaseViewController {
    
    private let mainView = BoardCollectionView()
    private let viewModel = BoardReadViewModel()
    private let disposeBag = DisposeBag()
    
    var postData: Post?
    var imageList: [UIImage] = []
    
    private var deletePost = PublishRelay<Bool>()
    
    
    override func loadView() {
        self.view = mainView
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        viewModel.postData = post
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(refeshHeader), name: .reloadHeader, object: nil)
        
        mainView.postData = post
        
        var urls: [String] = []
        post.image.forEach {
            urls.append(BaseURL.baseURL + "/" + $0)
        }
        mainView.imageURL = urls
        updateSnapShot()
        configNavBar()
        
    }
    
    @objc private func refeshHeader() {
        updateSnapShot()
    }
    
    private func bind() {
        
        let input = BoardReadViewModel.Input(delete: deletePost)
        
        let output = viewModel.transform(input: input)
        
        
        output?.errorMsg
            .bind(with: self, onNext: { owner, value in
                owner.showToastMessage(message: value, position: .top)
            })
            .disposed(by: disposeBag)
        
        output?.successDelete
            .bind(with: self, onNext: { owner, value in
                owner.showOKAlert(title: "", message: "삭제가 완료되었습니다.") {
                    NotificationCenter.default.post(name: .refresh, object: nil)
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output?.tokenRequest
            .bind(with: self, onNext: { owner, value in
                switch value {
                case .success:
                    break
                case .login:
                    owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                        UserDefaultsHelper.isLogin = false
                        // 로그인 뷰로 present
                        let vc = LoginViewController()
                        vc.transition = .presnt
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.completionHandler = {
                            owner.deletePost.accept(true)
                        }
                        owner.present(vc, animated: true)
                    }
                case .error:
                    owner.showOKAlert(title: "요청을 처리하지 못하였습니다. 다시 시도해주세요.", message: "") { }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func updateSnapShot() {
//        print("update")
        var snapShot = NSDiffableDataSourceSnapshot<Int, CommentModel>()
        snapShot.appendSections([0])
        snapShot.appendItems(dummyComment)
        mainView.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func configNavBar() {
        var menuItems: [UIAction] = []
        
        let editAction = UIAction(title: "Edit") { [weak self] action in
            guard let self = self else { return }
            guard let data = postData else {
                self.showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") { }
                return
            }
            
            let vc = BoardWriteViewController()
            vc.boardMode = .edit(data: data)
            self.navigationController?.pushViewController(vc, animated: false)
        }
        let deleteAction = UIAction(title: "Delete") { [weak self] action in
            guard let self = self else { return }
            self.showAlertWithCancel(title: "", message: "해당 게시글을 삭제하시겠어요?") {
                self.deletePost.accept(true)
            } cancelHandler: {
                
            }
            
        }
        menuItems.append(editAction)
        menuItems.append(deleteAction)
        
        var menu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image:  Constants.Image.menuButton, primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    
    
}
