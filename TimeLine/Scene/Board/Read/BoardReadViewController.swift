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
    
    private let mainView = BoardReadView()//BoardCollectionView()
    private let viewModel = BoardReadViewModel()
    private let disposeBag = DisposeBag()
    
    var postData: Post?
    var imageList: [UIImage] = []
    
    private var deletePost = PublishRelay<Bool>()
    private let commentWrite = PublishRelay<CommentRequest>()
    private let dispatchGroup = DispatchGroup()
    
    private let deviceWidth = UIScreen.main.bounds.size.width
    
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
        
        bind()
        updateSnapShot()
        configNavBar()
        //commentTest()
    }
    
    func commentTest() {
        CommentAPIManager.shared.request(api: .write(id: postData!.id, data: CommentRequest(content: "댓글 테스트")), type: Comment.self)
            .subscribe(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configData()
    }
    
    private func configData() {
        
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        
        mainView.nickname.text = post.creator.nick
        mainView.date.text = String.convertDateFormat(date: post.time)
        mainView.titleLabel.text = post.title
        mainView.contentLabel.text = post.content
        
        for i in 0..<post.image.count {
            
            mainView.imgList[i].setImage(with: post.image[i], resize: deviceWidth-30)
            
        }
        
        
    }
    
    @objc private func refeshHeader() {
        print(#function)
        updateSnapShot()
    }
    
    private func bind() {
        
        let input = BoardReadViewModel.Input(
            delete: deletePost,
            commentWrite: commentWrite
        )
        
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
        mainView.commentWriteView.textView.rx.didChange
            .bind(with: self) { owner, _ in
                let commentWriteView = owner.mainView.commentWriteView
                let size = CGSize(width: commentWriteView.frame.width, height: .infinity)
                let estimatedSize = commentWriteView.textView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= 100
                
                if isMaxHeight {
                    commentWriteView.textView.isScrollEnabled = true
                } else { commentWriteView.textView.isScrollEnabled = false }
            }
            .disposed(by: disposeBag)
        
        mainView.commentWriteView.postButton.rx.tap
            .withLatestFrom(mainView.commentWriteView.textView.rx.text.orEmpty) { _, text in
                return CommentRequest(content: text)
            }
            .bind(with: self) { owner, value in
                owner.commentWrite.accept(value)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, CommentModel>()
        snapShot.appendSections([0])
        snapShot.appendItems(dummyComment)
        mainView.tabledataSource.apply(snapShot, animatingDifferences: false)
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
            vc.modalPresentationStyle = .fullScreen
            vc.postHandler = { value in
                self.postData = value
                print(value)
                self.updateSnapShot()
                
            }
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
