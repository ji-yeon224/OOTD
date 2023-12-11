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
                        value.onNext(RefreshResult.success(token: token.token))
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
                            let error = NetworkError(statusCode: code, description: errorType.localizedDescription)
                            value.onNext(RefreshResult.login(error: error))
                        case .noExpire:
                            value.onNext(RefreshResult.success(token: UserDefaultsHelper.token))
                        }
                    }
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        
    }
    
    func newTokenRequest() -> Observable<Result<Bool, NetworkError>> {
        
        
        
        return Observable.create { value in
            AuthenticationAPIManager.shared.request(api: .refresh, successType: RefreshToken.self)
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let token):
                        debugPrint("[ACCESS TOKEN REFRESH]")
                        UserDefaultsHelper.token = token.token
                        value.onNext(.success(true))
                    case .failure(let error):
                        let code = error.statusCode
                        
                        guard let errorType = RefreshError(rawValue: code) else {
                            if let error = CommonError(rawValue: code) {
                                debugPrint("[DEBUG-REFRESH: \(code)] = \(error.errorDescription ?? "")")
                                value.onNext(.failure(NetworkError(statusCode: code, description: error.localizedDescription)))
                            }
                            return
                        }
                        debugPrint("[DEBUG-REFRESH] ", code, error.description)
                        value.onNext(.failure(NetworkError(statusCode: code, description: errorType.localizedDescription)))
                    }
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        
    }
    
    
}
