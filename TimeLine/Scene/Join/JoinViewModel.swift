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
        
        let joinCompleted: PublishSubject<UserInfoResponse>
        let errorMsg: PublishSubject<String>
        let emailValidation: PublishSubject<Bool>
        
    }
    
    func transform(input: Input) -> Output {
        
        let joinCompleted: PublishSubject<UserInfoResponse> = PublishSubject()
        let errorMsg: PublishSubject<String> = PublishSubject()
        let validation = PublishSubject<Bool>()
        
        input.emailText
            .map {
                return $0.trimmingCharacters(in: .whitespaces)
            }
            .bind(to: email)
            .disposed(by: disposeBag)
        
        // 이메일 유효성 검사 - 입력 하고 1초 후 체크
        input.emailText.changed
            .map {
                return $0.trimmingCharacters(in: .whitespaces)
            }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .debug()
            .flatMap { email in
                return AuthenticationAPIManager.shared.request(api: .emailValidation(email: email), successType: ResponseMessage.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    validation.onNext(true)
                case .failure(let error):
                    validation.onNext(false)
                    let code = error.statusCode
                    debugPrint("[Debug]", error.statusCode, error.description)
                    guard let errorType = LoginError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        return
                    }
                    
                    errorMsg.onNext(errorType.errorDescription ?? "")
                }
            }
            .disposed(by: disposeBag)
        
        input.passText
            .map {
                return $0.trimmingCharacters(in: .whitespaces)
            }
            .bind(to: password)
            .disposed(by: disposeBag)
        
        input.nickText
            .map {
                return $0.trimmingCharacters(in: .whitespaces)
            }
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        input.birthText
            .bind(to: birthday)
            .disposed(by: disposeBag)
        
        
        input.buttonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                return AuthenticationAPIManager.shared.request(api: .join(joinInfo: Join(email: self.email.value, password: self.password.value, nick: self.nickname.value, birthDay: self.birthday.value)), successType: UserInfoResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    joinCompleted.onNext(value)
                case .failure(let error):
                    debugPrint("[Debug]", error.statusCode, error.description)
                    let code = error.statusCode
                    guard let errorType = JoinError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        return
                    }
                    errorMsg.onNext(errorType.errorDescription ?? "")
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(joinCompleted: joinCompleted, errorMsg: errorMsg, emailValidation: validation)
        
        
    }
    
    private func getAge(birthday: Date) -> Bool {
            
        let age = Calendar.current.dateComponents([.year], from: birthday, to: Date())
        return Int(age.year!) >= 17
        
    }
    
}
