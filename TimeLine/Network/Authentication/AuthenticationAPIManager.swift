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
        var provider = MoyaProvider<AuthenticationAPI>()
        switch api {
        case .login, .join, .emailValidation:
            provider = self.provider
        case .content:
            break
        case .refresh, .withdraw:
            provider = self.authprovider
        }
        
        return Single.create { single in
            provider.request(api) { response in
//                print("AuthAPIManager response", response)
                switch response {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data.data)
//                            print("SUCCESS")
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
                    print("AuthManager FAIL ", error)
                    guard let response = error.response else {
                        single(.success(.failure(NetworkError(statusCode: 500, description: "문제가 발생하였습니다."))))
                        return
                    }
                    let error = NetworkError(statusCode: response.statusCode, description: response.description)
                    
                    single(.success(.failure(error)))
                    
                }
            }
            return Disposables.create()
        }
        
    }
    

    
}
