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
    private var comments: [Comment] = []
    
    private var deletePost = PublishRelay<Bool>()
    private let commentWrite = PublishRelay<CommentRequest>()
    private let commentDelete = PublishRelay<(String, Int)>()
    private let dispatchGroup = DispatchGroup()
    
    private let deviceWidth = UIScreen.main.bounds.size.width
    private var isNeedRefresh = false
    
    override func loadView() {
        self.view = mainView
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        viewModel.postData = post
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configData()
        updateSnapShot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isNeedRefresh {
            NotificationCenter.default.post(name: .refresh, object: nil)
        }
    }
    
    private func configData() {
        
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        
        mainView.nickname.text = post.creator.nick
        mainView.date.text = String.convertDateFormat(date: post.time)
        mainView.titleLabel.text = post.title
        mainView.contentLabel.text = post.content
        mainView.commentLabel.text = "댓글 \(post.comments.count)개"
        comments = post.comments.reversed()
        for i in 0..<post.image.count {
            
            mainView.imgList[i].setImage(with: post.image[i], resize: deviceWidth-30)
            
        }
        
        if post.creator.id == UserDefaultsHelper.userID {
            configNavBar()
        }
        configureDataSource()
        
    }
    
    
    private func bind() {
        
        let input = BoardReadViewModel.Input(
            delete: deletePost,
            commentWrite: commentWrite,
            commentContent: mainView.commentWriteView.textView.rx.text.orEmpty,
            commentDelete: commentDelete
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
        
        output?.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.initToken()
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
            }
            .disposed(by: disposeBag)
        
        
        
        output?.commentWrite
            .bind(with: self, onNext: { owner, value in
                owner.comments.append(value)
                owner.updateSnapShot()
                owner.mainView.commentWriteView.textView.text = ""
                owner.showOKAlert(title: "", message: "댓글 작성이 완료되었습니다!") {
                    owner.mainView.scrollView.scrollToBottom()
                    owner.isNeedRefresh = true
                    owner.mainView.commentLabel.text = "댓글 \(owner.comments.count)개"
                }
                
                
            })
            .disposed(by: disposeBag)
        
        output?.commentIsEnable
            .bind(to: mainView.commentWriteView.postButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output?.successCommentDelete
            .bind(with: self, onNext: { owner, value in
                owner.showToastMessage(message: "댓글 삭제가 완료되었습니다!", position: .center)
                owner.comments.remove(at: value)
                owner.mainView.commentLabel.text = "댓글 \(owner.comments.count)개"
                owner.updateSnapShot()
                owner.isNeedRefresh = true
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
                
                if commentWriteView.textView.text.count > 0 {
                    commentWriteView.placeholderLabel.isHidden = true
                } else {
                    commentWriteView.placeholderLabel.isHidden = false
                }
                
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
        var snapShot = NSDiffableDataSourceSnapshot<Int, Comment>()
        snapShot.appendSections([0])
        snapShot.appendItems(comments)
        mainView.dataSource.apply(snapShot)
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
//                print(value)
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
    
    func configureDataSource() {
        
        mainView.dataSource = UITableViewDiffableDataSource<Int, Comment>(tableView: mainView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardCommentCell.identifier, for: indexPath) as? BoardCommentCell else { return UITableViewCell() }
            cell.nicknameLabel.text = itemIdentifier.creator.nick
            cell.dateLabel.text = String.convertDateFormat(date: itemIdentifier.time)
            cell.contentLabel.text = itemIdentifier.content
            if itemIdentifier.creator.id == UserDefaultsHelper.userID {
                cell.deleteButton.isHidden = false
                cell.deleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.showAlertWithCancel(title: "", message: "해당 댓글을 삭제하시겠어요?") {
                            owner.commentDelete.accept((itemIdentifier.id, indexPath.row))
                        } cancelHandler: { }

                        
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            return cell
        })
        
        
        
    }
    
    
}
