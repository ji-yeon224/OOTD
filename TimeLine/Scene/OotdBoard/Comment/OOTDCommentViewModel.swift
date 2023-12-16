//
//  OOTDCommentViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import Foundation
import RxSwift
import RxCocoa

final class OOTDCommentViewModel {
    
    private let disposeBag = DisposeBag()
    var id: String = ""
    
    struct Input {
        
        let commentWrite: PublishRelay<CommentRequest>
        let commentContent: ControlProperty<String>
//        let commentDelete: PublishRelay<(String, Int)>
    }
    
    struct Output {
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
        let commentIsEnable: BehaviorRelay<Bool>
        let commentWrite: PublishRelay<Comment>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        let commentWrite = PublishRelay<Comment>()
        let commentIsEnable = BehaviorRelay(value: false)
        
        input.commentWrite
            .flatMap {
                CommentAPIManager.shared.request(api: .write(id: self.id, data: $0), type: Comment.self)
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
        return Output(errorMsg: errorMsg, loginRequest: loginRequest, commentIsEnable: commentIsEnable, commentWrite: commentWrite)
    }
    
    
}
