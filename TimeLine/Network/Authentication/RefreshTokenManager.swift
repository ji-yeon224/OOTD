//
//  RefreshTokenManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/17/23.
//

import Foundation
import RxSwift

final class RefreshTokenManager {
    
    static let shared = RefreshTokenManager()
    private init() { }
    let disposeBag = DisposeBag()
    func tokenRequest() -> Observable<RefreshResult> {
        
        
        
        return Observable.create { value in
            AuthenticationAPIManager.shared.request(api: .refresh, successType: RefreshToken.self)
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let token):
                        debugPrint("[ACCESS TOKEN REFRESH]")
                        UserDefaultsHelper.token = token.token
                        value.onNext(RefreshResult.success)
                    case .failure(let error):
                        let code = error.statusCode
                        
                        guard let errorType = RefreshError(rawValue: code) else {
                            if let error = CommonError(rawValue: code) {
                                debugPrint("[DEBUG-REFRESH: \(code)] = \(error.errorDescription ?? "")")
                                value.onNext(RefreshResult.error)
                            }
                            return
                        }
                        debugPrint("[DEBUG-REFRESH] ", code, error.description)
                        switch errorType {
                        case .wrongAuth, .fobidden, .expireRefreshToken:
                            value.onNext(RefreshResult.login)
                        case .noExpire:
                            value.onNext(RefreshResult.success)
                        }
                    }
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        
    }
    
    
}
