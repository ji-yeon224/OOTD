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
                
                switch result {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(RefreshToken.self, from: data.data)
                            UserDefaultsHelper.token = result.token
                            
                            value.onNext(RefreshResult.success(token: result.token))
                        } catch {
                            print("DECODING ERROR")
                            value.onNext(RefreshResult.error)
                        }
                    } 
//                    else {
//                        do {
//                            let result = try JSONDecoder().decode(ErrorModel.self, from: data.data)
//                            debugPrint("[DEBUG - API REQUEST", result.message)
//                            guard let errorType = RefreshError(rawValue: statusCode) else {
//                                if let error = CommonError(rawValue: statusCode) {
//                                    debugPrint("[DEBUG-REFRESH: \(statusCode)] = \(error.errorDescription ?? "")")
//                                    value.onNext(RefreshResult.error)
//                                }
//                                return
//                            }
//                            debugPrint("[DEBUG-REFRESH] ", statusCode, errorType.localizedDescription)
//                            switch errorType {
//                            case .wrongAuth, .fobidden, .expireRefreshToken:
//                                let error = NetworkError(statusCode: statusCode, description: errorType.localizedDescription)
//                                value.onNext(RefreshResult.login(error: error))
////                                UserDefaultsHelper.initToken()
//                                
//                            case .noExpire:
//                                value.onNext(RefreshResult.success(token: UserDefaultsHelper.token))
//                            }
//                        } catch {
//                            print("DECODING ERROR")
//                        }
//                        
//                       
//                    }
                case .failure(let error):
                    print("TokenManager Fail---- ", error.response!)
                    
                    if let code = error.response?.statusCode {
                        if let error = RefreshError(rawValue: code) {
                            switch error {
                            case .wrongAuth, .fobidden, .expireRefreshToken:
                                let error = NetworkError(statusCode: code, description: error.localizedDescription)
                                UserDefaultsHelper.initToken()
                                value.onNext(RefreshResult.login(error: error))
                            case .noExpire:
                                
                                value.onNext(RefreshResult.success(token: UserDefaultsHelper.token))
                            }
                        }
                    } else {
                        value.onNext(RefreshResult.error)
                    }
//                    let error = NetworkError(statusCode: error.errorCode, description: error.localizedDescription)
                    
                    
                }
            }
            return Disposables.create()
        }
        
        
    }
    
}
