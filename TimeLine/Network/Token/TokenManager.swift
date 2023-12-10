//
//  TokenRequest.swift
//  TimeLine
//
//  Created by 김지연 on 12/8/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

final class TokenManager {
    
    static let shared = TokenManager()
    private init() { }
    
    private let provider = MoyaProvider<AuthenticationAPI>()
    
    func request() -> Observable<RefreshResult> {
        
        return Observable.create { value in
            self.provider.request(.refresh) { result in
                print("---TokenManager Result----- ", result)
                switch result {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(RefreshToken.self, from: data.data)
                            UserDefaultsHelper.token = result.token
                            print(UserDefaultsHelper.token)
                            value.onNext(RefreshResult.success)
                        } catch {
                            print("DECODING ERROR")
                            value.onNext(RefreshResult.error)
                        }
                    } else {
                        do {
                            let result = try JSONDecoder().decode(ErrorModel.self, from: data.data)
                            debugPrint("[DEBUG - API REQUEST", result.message)
                            guard let errorType = RefreshError(rawValue: statusCode) else {
                                if let error = CommonError(rawValue: statusCode) {
                                    debugPrint("[DEBUG-REFRESH: \(statusCode)] = \(error.errorDescription ?? "")")
                                    value.onNext(RefreshResult.error)
                                }
                                return
                            }
                            debugPrint("[DEBUG-REFRESH] ", statusCode, errorType.localizedDescription)
                            switch errorType {
                            case .wrongAuth, .fobidden, .expireRefreshToken:
                                value.onNext(RefreshResult.login)
//                                UserDefaultsHelper.initToken()
                                
                            case .noExpire:
                                value.onNext(RefreshResult.success)
                            }
                        } catch {
                            print("DECODING ERROR")
                        }
                        
                       
                    }
                case .failure(let error):
                    print("TokenManager Fail ", error)
                    if let code = error.response?.statusCode {
                        if let error = RefreshError(rawValue: code) {
                            switch error {
                            case .wrongAuth, .fobidden, .expireRefreshToken:
                                value.onNext(RefreshResult.login)
//                                UserDefaultsHelper.initToken()
                                
                            case .noExpire:
                                value.onNext(RefreshResult.success)
                            }
                        }
                    }
//                    let error = NetworkError(statusCode: error.errorCode, description: error.localizedDescription)
                    
                    value.onNext(RefreshResult.error)
                }
            }
            return Disposables.create()
        }
        
        
    }
    
}
