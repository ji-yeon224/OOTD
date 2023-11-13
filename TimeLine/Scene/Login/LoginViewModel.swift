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
    
    
    let email = BehaviorRelay(value: "")
    let pass = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        
        let successToken: PublishSubject<LoginToken>
        let errorMsg: PublishSubject<String>
        
    }
    
    func transform(input: Input) -> Output {
        
        let tokens: PublishSubject<LoginToken> = PublishSubject()
        let errorMsg: PublishSubject<String> = PublishSubject()
        
        input.email
            .bind(to: email)
            .disposed(by: disposeBag)
        input.password
            .bind(to: pass)
            .disposed(by: disposeBag)
        
        input.buttonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                APIManager.shared.request(api: .login(email: self.email.value, password: self.pass.value))
            }
            .subscribe(with: self) { owner, result in
                tokens.onNext(result)
            } onError: { owner, error in
                errorMsg.onNext(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        return Output(successToken: tokens, errorMsg: errorMsg)
        
    }
    
}
