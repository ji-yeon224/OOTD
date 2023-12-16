//
//  OOTDCommentViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDCommentViewController: BaseViewController {
    
    private let mainView = OOTDCommentView()
    private let disposeBag = DisposeBag()
    var comments: [Comment] = []
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    override func configure() {
        super.configure()
        configureDataSource()
        updateSnapShot()
    }
    
    private func bind() {
        
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
//                            owner.commentDelete.accept((itemIdentifier.id, indexPath.row))
                        } cancelHandler: { }

                        
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            return cell
        })
        
        
        
    }
    
}
