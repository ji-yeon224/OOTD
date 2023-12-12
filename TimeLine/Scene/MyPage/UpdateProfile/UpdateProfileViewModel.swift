//
//  UpdateProfileViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateProfileViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nickNameText: ControlProperty<String>
        let updateProfile: PublishRelay<ProfileUpdateRequest>
    }
    
    struct Output {
        
        let nickNameValid: PublishRelay<(Bool, String)>
        let updateSuccess: PublishRelay<MyProfileResponse>
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        
        let nickNameValid = PublishRelay<(Bool, String)>()
        let updateSuccess = PublishRelay<MyProfileResponse>()
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        
        input.nickNameText
            .map {
                $0.trimmingCharacters(in: .whitespaces)
            }
            .bind(with: self) { owner, value in
                let valid = value.count >= 2 && value.count <= 8
                nickNameValid.accept((valid, value))
            }
            .disposed(by: disposeBag)
        
        input.updateProfile
            .flatMap {
                ProfileAPIManager.shared.request(api: .update(data: $0), type: MyProfileResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    updateSuccess.accept(value)
                case .failure(let error):
                    guard let errorType = ProfileError(rawValue: error.statusCode) else {
                        if let common = CommonError(rawValue: error.statusCode) {
                            errorMsg.accept(common.localizedDescription)
                        }
                        else {
                            loginRequest.accept(true)
                        }
                        return
                    }
                    errorMsg.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
            
        
        
        return Output(nickNameValid: nickNameValid, updateSuccess: updateSuccess, errorMsg: errorMsg, loginRequest: loginRequest)
        
    }
    
    
    
}
