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
    private let withdrawRequest = PublishSubject<Bool>()
    
    struct Input {
        
        let contentButtonTap: ControlEvent<Void>
        let withdrawButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
        
        let successMsg: PublishSubject<String>
        let errorMsg: PublishSubject<String>
        let tokenRequest: PublishSubject<RefreshResult>
        let withdraw: PublishSubject<Bool>
        let loginRequest: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let successMsg = PublishSubject<String>()
        let errorMsg: PublishSubject<String> = PublishSubject()
        let tokenRequest = PublishSubject<RefreshResult>()
        let withdraw = PublishSubject<Bool>()
        let loginRequest = PublishRelay<Bool>()
        
        
        // 게시글
        input.contentButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                AuthenticationAPIManager.shared.request(api: .content, successType: ResponseMessage.self)
            }
            .subscribe(with: self) { owner, response in
                print(UserDefaultsHelper.token)
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
                        errorMsg.onNext("forbidden")
                    
                    
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        input.withdrawButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.withdrawRequest.onNext(true)
            }
            .disposed(by: disposeBag)
        
        withdrawRequest
            .flatMap { _ in
                AuthenticationAPIManager.shared.request(api: .withdraw, successType: UserInfoResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("-----success------", result)
                    withdraw.onNext(true)
                case .failure(let error):
                    print("----error-----", error)
                    loginRequest.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
//        withdrawRequest
//            .flatMap { _ in
//                AuthenticationAPIManager.shared.request(api: .withdraw, successType: UserInfoResponse.self)
//            }
//            .subscribe(with: self) { owner, response in
//                switch response {
//                case .success(_):
//                    withdraw.onNext(true)
//                case .failure(let error):
//                    let code = error.statusCode
//                    guard let errorType = WithdrawError(rawValue: code) else {
//                        if let commonError = CommonError(rawValue: code) {
//                            errorMsg.onNext(commonError.localizedDescription)
//                        }
//                        return
//                    }
//                    
//                    switch errorType {
//                    case .invalidToken, .expireToken:
//                        let result = RefreshTokenManager.shared.tokenRequest()
//                        result
//                            .bind(with: self, onNext: { owner, result in
//                                debugPrint("[TOKEN 재발급]", String(describing: UserDefaultsHelper.token))
//                                switch result {
//                                case .success:
//                                    owner.withdrawRequest.onNext(true)
//                                case .login, .error:
//                                    tokenRequest.onNext(result)
//                                }
//                                
//                                
//                                
//                            })
//                            .disposed(by: owner.disposeBag)
//                    case .forbidden:
//                        tokenRequest.onNext(RefreshResult.login)
//                    
//                    }
//                    
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(successMsg: successMsg, errorMsg: errorMsg, tokenRequest: tokenRequest, withdraw: withdraw, loginRequest: loginRequest)
        
    }
    
    
    
    
}
