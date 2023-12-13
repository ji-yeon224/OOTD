//
//  MyPageViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let requestProfile: BehaviorRelay<Bool>
    }
    
    struct Output {
        let profile: PublishRelay<MyProfileResponse>
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let profile = PublishRelay<MyProfileResponse>()
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        
        input.requestProfile
            .flatMap { _ in
                ProfileAPIManager.shared.request(api: .myProfile, type: MyProfileResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    profile.accept(value)
                case .failure(_):
                    loginRequest.accept(true)
//                    errorMsg.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
       
        
        
        return Output(
            profile: profile,
            errorMsg: errorMsg,
            loginRequest: loginRequest
        )
    }
    
    
    
}
