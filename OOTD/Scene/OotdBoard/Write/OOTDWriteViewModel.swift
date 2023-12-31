//
//  OOTDWriteViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import Foundation
import RxSwift
import RxCocoa

final class OOTDWriteViewModel {
    
    private let disposeBag = DisposeBag()
    
    
    struct Input {
        let postRequest: PublishRelay<PostWrite>
        let updateRequest: PublishRelay<(PostWrite, String)>
    }
    
    struct Output {
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
        let successPost: PublishRelay<(Bool, String)>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        let successPost = PublishRelay<(Bool, String)>()
        
        input.postRequest
            .flatMap {
                PostAPIManager.shared.postrequest(api: .write(data: $0), type: Post.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    successPost.accept((true, ""))
                    NotificationCenter.default.post(name: .refreshPhoto, object: nil)
                case .failure(let error):
                    let code = error.statusCode
                    debugPrint("[ERROR] ", code, error.localizedDescription)
                    guard let errorType = PostWriteError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    errorMsg.accept(errorType.localizedDescription)
                    successPost.accept((false, errorType.localizedDescription))
                }
            }
            .disposed(by: disposeBag)
        
        input.updateRequest
            .flatMap {
                PostAPIManager.shared.postrequest(api: .update(id: $0.1, data: $0.0), type: Post.self)
            }
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    print("[SUCCESS] ",data)
                    successPost.accept((true, ""))
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = PostUpdateError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
//                            print(commonError.localizedDescription)
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    
                    errorMsg.accept(errorType.localizedDescription)
                    successPost.accept((false, errorType.localizedDescription))
                    
                }
            })
            .disposed(by: disposeBag)
        
        return Output(errorMsg: errorMsg, loginRequest: loginRequest, successPost: successPost)
    }
    
    
    
}
