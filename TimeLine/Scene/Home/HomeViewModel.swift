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
 
        return Output(successMsg: successMsg, errorMsg: errorMsg, tokenRequest: tokenRequest, withdraw: withdraw, loginRequest: loginRequest)
        
    }
    
    
    
    
}
