//
//  OOTDCommentViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

final class OOTDCommentViewController: BaseViewController {
    
    private let mainView = OOTDCommentView()
    private let viewModel = OOTDCommentViewModel()
    private let disposeBag = DisposeBag()
    
    private let commentDelete = PublishRelay<(String, Int)>()
    
    var comments: [Comment] = []
    var id: String?
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        title = "댓글 \(comments.count)개"
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func configure() {
        super.configure()
        configureDataSource()
        updateSnapShot()
        guard let id = id else { return }
        viewModel.id = id
    }
    
    private func bind() {
        
        let commentWrite = PublishRelay<CommentRequest>()
        
        let input = OOTDCommentViewModel.Input(
            commentWrite: commentWrite,
            commentContent: mainView.commentWriteView.textView.rx.text.orEmpty,
            commentDelete: commentDelete
        )
        
        let output = viewModel.transform(input: input)
        
        output.commentWrite
            .bind(with: self, onNext: { owner, value in
                owner.comments.append(value)
                owner.updateSnapShot()
                owner.mainView.commentWriteView.textView.text = ""
                owner.showOKAlert(title: "", message: "댓글 작성이 완료되었습니다!") {
                    owner.mainView.commentWriteView.placeholderLabel.isHidden = false
                    owner.title = "댓글 \(owner.comments.count)개"
                }
                
                
            })
            .disposed(by: disposeBag)
        
        output.successCommentDelete
            .bind(with: self, onNext: { owner, value in
                owner.showToastMessage(message: "댓글 삭제가 완료되었습니다!", position: .center)
                owner.comments.remove(at: value)
                owner.title = "댓글 \(owner.comments.count)개"
                owner.updateSnapShot()
                
            })
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self, onNext: { owner, value in
                owner.showToastMessage(message: value, position: .top)
            })
            .disposed(by: disposeBag)
        
        output.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.initToken()
                    // 로그인 뷰로 present
                    let vc = LoginViewController()
                    vc.transition = .presnt
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    
                    owner.present(vc, animated: true)
                }
            }
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
        
        mainView.commentWriteView.textView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                owner.sheetPresentationController?.animateChanges {
                    owner.sheetPresentationController?.selectedDetentIdentifier = .large
                }
            }
            .disposed(by: disposeBag)
        
        mainView.commentWriteView.postButton.rx.tap
            .withLatestFrom(mainView.commentWriteView.textView.rx.text.orEmpty) { _, text in
                return CommentRequest(content: text)
            }
            .bind(with: self) { owner, value in
                owner.view.endEditing(true)
                commentWrite.accept(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Comment>()
        snapShot.appendSections([0])
        snapShot.appendItems(comments)
        mainView.dataSource.apply(snapShot)
    }
    
    private func configureDataSource() {
        
        mainView.dataSource = UITableViewDiffableDataSource<Int, Comment>(tableView: mainView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardCommentCell.identifier, for: indexPath) as? BoardCommentCell else { return UITableViewCell() }
            cell.nicknameLabel.text = itemIdentifier.creator.nick
            cell.dateLabel.text = String.convertDateFormat(date: itemIdentifier.time)
            cell.contentLabel.text = itemIdentifier.content
            cell.selectionStyle = .none
            if let profile = itemIdentifier.creator.profile {
                cell.profileImage.setImage(with: profile, resize: 30)
            }
            
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
