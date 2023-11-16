//
//  LoginViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    
    private let email = BehaviorRelay(value: "")
    private let pass = BehaviorRelay(value: "")
    
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        
//        let successToken: PublishSubject<LoginToken>
        let errorMsg: PublishSubject<String>
        let success: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        //let tokens: PublishSubject<LoginToken> = PublishSubject()
        let errorMsg: PublishSubject<String> = PublishSubject()
        let successValue = BehaviorRelay(value: false)
        
        input.email
            .bind(to: email)
            .disposed(by: disposeBag)
        input.password
            .bind(to: pass)
            .disposed(by: disposeBag)
        
        input.buttonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                return AuthenticationAPIManager.shared.request(api: .login(userInfo: Login(email: self.email.value, password: self.pass.value)), successType: LoginToken.self)
            }
            .subscribe(with: self, onNext: { owner, response in
                switch response {
                case .success(let result):
                    //tokens.onNext(result)
                    successValue.accept(true)
                    UserDefaultsHelper.shared.token = result.token
                    UserDefaultsHelper.shared.refreshToken = result.refreshToken
                case .failure(let error):
                    let code = error.statusCode
                    guard let errorType = LoginError(rawValue: code) else { return }
                    debugPrint("[Debug]", error.statusCode, error.description)
                    errorMsg.onNext(errorType.errorDescription ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        
            
            
        
        return Output(errorMsg: errorMsg, success: successValue)
        
    }
    
}
