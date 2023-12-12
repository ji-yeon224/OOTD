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
        
    }
    
    struct Output {
        
        
        let nickNameValid: PublishRelay<(Bool, String)>
        
    }
    
    
    func transform(input: Input) -> Output {
        
        let nickNameValid = PublishRelay<(Bool, String)>()
        // 닉네임 조건 충족, 원래 닉네임과 달라야 함
        input.nickNameText
            .map {
                $0.trimmingCharacters(in: .whitespaces)
            }
            .bind(with: self) { owner, value in
                let valid = value.count >= 2 && value.count <= 8
                nickNameValid.accept((valid, value))
            }
            .disposed(by: disposeBag)
        
        return Output(nickNameValid: nickNameValid)
        
    }
    
    
    
}
