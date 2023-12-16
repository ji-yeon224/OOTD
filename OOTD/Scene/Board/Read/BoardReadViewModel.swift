//
//  BoardReadViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/23/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardReadViewModel {
    
    var postData: Post?
    var like: Bool = false
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let delete: PublishRelay<Bool>
        let commentWrite: PublishRelay<CommentRequest>
        let commentContent: ControlProperty<String>
        let commentDelete: PublishRelay<(String, Int)>
        let likeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let errorMsg: PublishRelay<String>
        let successDelete: PublishRelay<Bool>
        let commentWrite: PublishRelay<Comment>
        let commentIsEnable: BehaviorRelay<Bool>
        let loginRequest: PublishRelay<Bool>
        let successCommentDelete: PublishRelay<Int>
        let likeValue: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output? {
        
        guard let post = postData else { print("nil")
            return nil }
//        print(post)
        let errorMsg = PublishRelay<String>()
        let successDelete = PublishRelay<Bool>()
        let commentWrite = PublishRelay<Comment>()
        let commentIsEnable = BehaviorRelay(value: false)
        let loginRequest = PublishRelay<Bool>()
        let successCommentDelete = PublishRelay<Int>()
        let likeValue = PublishRelay<Bool>()
        
        var deleteCommentIdx: Int?
        
        input.delete
            .flatMap { _ in
                return PostAPIManager.shared.postrequest(api: .delete(id: post.id), type:  DeleteResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(_):
//                    debugPrint("[DELETE POST SUCCESS]")
                    successDelete.accept(true)
                case .failure(let error):
                    let code = error.statusCode
                    guard let errorType = PostDeleteError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        return
                    }
                    debugPrint("[DEBUG-POST] ", error.statusCode, error.description)
                    errorMsg.accept(errorType.localizedDescription)
                    
                    
                }
            }
            .disposed(by: disposeBag)
        
        
        input.commentWrite
            .flatMap {
                CommentAPIManager.shared.request(api: .write(id: post.id, data: $0), type: Comment.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print(result)
                    commentWrite.accept(result)
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = CommentError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    debugPrint("[DEBUG-POST] ", error.statusCode, error.description)
                    
                    errorMsg.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.commentContent
            .bind(with: self) { owner, value in
                if value.trimmingCharacters(in: .whitespaces).count > 0 {
                    commentIsEnable.accept(true)
                } else {
                    commentIsEnable.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.commentDelete
            .map {
                deleteCommentIdx = $0.1
                return $0.0
            }
            .flatMap {
                CommentAPIManager.shared.request(api: .delete(id: post.id, commentID: $0), type: CommentDelete.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    if let idx = deleteCommentIdx {
                        successCommentDelete.accept(idx)
                    }
                    
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = CommentError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    
                    errorMsg.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.likeButtonTap
            .flatMap {
                PostAPIManager.shared.postrequest(api: .like(id: post.id), type: LikeResponse.self)
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(_):
                    owner.like.toggle()
                    likeValue.accept(owner.like)
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let _ = LikeError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                }
            })
            .disposed(by: disposeBag)
            
        
        return Output(errorMsg: errorMsg, successDelete: successDelete, commentWrite: commentWrite, commentIsEnable: commentIsEnable, loginRequest: loginRequest, successCommentDelete: successCommentDelete, likeValue: likeValue)
        
    }
    
    
    
    
}
