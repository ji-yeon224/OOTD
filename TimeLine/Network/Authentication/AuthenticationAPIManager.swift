//
//  AuthenticationAPIManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

final class AuthenticationAPIManager {
    
    static let shared = AuthenticationAPIManager()
    private init() { }
    
    private let authprovider = MoyaProvider<AuthenticationAPI>(session: Session(interceptor: AuthInterceptor.shared))
    private let provider = MoyaProvider<AuthenticationAPI>()
    
    func request<T: Codable>(api: AuthenticationAPI, successType: T.Type) -> Single<Result<T, NetworkError>> {
        
        return Single.create { single in
            self.authprovider.request(api) { response in
                print(response)
                switch response {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data.data)
                            print("SUCCESS")
                            single(.success(.success(result)))
                        } catch {
                            print("DECODING ERROR")
                        }
                    } else {
                        do {
                            let result = try JSONDecoder().decode(ErrorModel.self, from: data.data)
                            debugPrint("[DEBUG - API REQUEST", result.message)
                            let error = NetworkError(statusCode: statusCode, description: result.message)
                            single(.success(.failure(error)))
                        } catch {
                            print("DECODING ERROR")
                        }
                        
                       
                    }
                    
                case .failure(let error):
                    let error = NetworkError(statusCode: error.errorCode, description: error.localizedDescription)
                    print("FAIL ", error)
                    single(.success(.failure(error)))
                    
                }
            }
            return Disposables.create()
        }
        
    }
    
//    func refreshRequest() -> Single<Result<RefreshToken, RefreshError>> {
//        
//        return Single.create { single in
//            self.provider.request(.refresh) { result in
//                switch result {
//                case .success(let data):
//                    let statusCode = data.statusCode
//                    if statusCode == 200 {
//                        let result = try! JSONDecoder().decode(RefreshToken.self, from: data.data)
//                        single(.success(.success(result)))
//                    } else {
//                        let error = RefreshError(rawValue: statusCode ?? 500)
//                        switch error {
//                        case .wrongAuth, .fobidden, .expireRefreshToken:
//                            <#code#>
//                        case .noExpire:
//                            <#code#>
//                        case .serverError:
//                            <#code#>
//                        
//                        }
//                        
//                    }
//                    
//                    
//                case .failure(let error):
//                }
//            }
//            
//            
//        }
//        
//        
//    }
        
    
    
   
    
    
}
