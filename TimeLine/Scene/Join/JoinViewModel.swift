//
//  JoinViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinViewModel {
    
    private let email = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    private let nickname = BehaviorRelay(value: "")
    private let birthday = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
        let emailText: ControlProperty<String>
        let passText: ControlProperty<String>
        let nickText: ControlProperty<String>
        let birthText: ControlProperty<String>
        let buttonTap: ControlEvent<Void>
        
    }
    
    struct Output {
        
        let joinCompleted: PublishSubject<JoinSuccess>
        let errorMsg: PublishSubject<String>
        
    }
    
    func transform(input: Input) -> Output {
        
        let joinCompleted: PublishSubject<JoinSuccess> = PublishSubject()
        let errorMsg: PublishSubject<String> = PublishSubject()
        
        input.emailText
            .bind(to: email)
            .disposed(by: disposeBag)
        
        input.passText
            .bind(to: password)
            .disposed(by: disposeBag)
        
        input.nickText
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        input.birthText
            .bind(to: birthday)
            .disposed(by: disposeBag)
        
        
        input.buttonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                return AuthenticationAPIManager.shared.request(api: .join(joinInfo: Join(email: self.email.value, password: self.password.value, nick: self.nickname.value, birthDay: self.birthday.value)), successType: JoinSuccess.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    joinCompleted.onNext(value)
                case .failure(let error):
                    errorMsg.onNext(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(joinCompleted: joinCompleted, errorMsg: errorMsg)
        
        
    }
    
}
