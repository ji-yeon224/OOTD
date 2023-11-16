//
//  HomeViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/16/23.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let tokenResult = PublishSubject<RefreshToken>()
    private let tokenExpire = PublishSubject<Bool>()
    
    struct Input {
        
        let contentButtonTap: ControlEvent<Void>
        let withdrawButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
        
        let successMsg: PublishSubject<String>
        let errorMsg: PublishSubject<String>
        let tokenRequest: PublishSubject<RefreshResult>
    }
    
    func transform(input: Input) -> Output {
        
        let successMsg = PublishSubject<String>()
        let errorMsg: PublishSubject<String> = PublishSubject()
        let tokenRequest = PublishSubject<RefreshResult>()
        
        // 게시글
        input.contentButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                AuthenticationAPIManager.shared.request(api: .content, successType: ResponseMessage.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    successMsg.onNext(result.message)
                    
                case .failure(let error):
                    let code = error.statusCode
                    if let commonError = CommonError(rawValue: code) {
                        errorMsg.onNext(commonError.localizedDescription)
                    }
                    guard let errorType = ContentError(rawValue: code) else { return }
                    debugPrint("[DEBUG-CONTENT] ", error.statusCode, error.description)
                    
                    switch errorType {
                    case .invalidToken, .expireToken: // 리프레시
                        let result = RefreshTokenManager.shared.tokenRequest()
                        result
                            .bind(to: tokenRequest)
                            .disposed(by: owner.disposeBag)
                    case .forbidden: // 로그아웃
                        break
                    
                    
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        return Output(successMsg: successMsg, errorMsg: errorMsg, tokenRequest: tokenRequest)
        
    }
    
    
    
    
}
