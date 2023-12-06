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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let delete: PublishRelay<Bool>
    }
    
    struct Output {
        let errorMsg: PublishRelay<String>
        let tokenRequest: PublishRelay<RefreshResult>
        let successDelete: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output? {
        
        guard let post = postData else { print("nil")
            return nil }
//        print(post)
        let errorMsg = PublishRelay<String>()
        let tokenRequest = PublishRelay<RefreshResult>()
        let successDelete = PublishRelay<Bool>()
        
        input.delete
            .flatMap { _ in
                return PostAPIManager.shared.request(api: .delete(id: post.id), type:  DeleteResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(_):
                    debugPrint("[DELETE POST SUCCESS]")
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
                    
                    switch errorType {
                    case .wrongAuth, .forbidden, .expireToken:
                        let result = RefreshTokenManager.shared.tokenRequest()
                        result
                            .bind(with: self) { owner, result in
                                if result == .success {
                                    input.delete.accept(true)
                                } else {
                                    tokenRequest.accept(result)
                                }
                            }
                            .disposed(by: owner.disposeBag)
                    
                    case .alreadyDelete:
                        errorMsg.accept(errorType.localizedDescription)
                    case .noAuthorization:
                        errorMsg.accept(errorType.localizedDescription)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        return Output(errorMsg: errorMsg, tokenRequest: tokenRequest, successDelete: successDelete)
        
    }
    
    
    
    
}
