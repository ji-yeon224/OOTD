//
//  AccountSettingViewModel.swift
//  OOTD
//
//  Created by 김지연 on 12/21/23.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountSettingViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let withdrawTap: PublishRelay<Bool>
    }
    
    struct Output {
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
        let withdraw: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        let withdraw = PublishRelay<Bool>()
        
        input.withdrawTap
            .flatMap { _ in
                AuthenticationAPIManager.shared.request(api: .withdraw, successType: UserInfoResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("-----success------", result)
                    withdraw.accept(true)
                case .failure(let error):
                    print("----error-----", error)
                    loginRequest.accept(true)
                }
            }
            .disposed(by: disposeBag)
       
        
        
        return Output(
            errorMsg: errorMsg,
            loginRequest: loginRequest,
            withdraw: withdraw
        )
    }
}
