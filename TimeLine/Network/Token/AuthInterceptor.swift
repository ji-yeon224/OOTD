//
//  AuthIntercepter.swift
//  TimeLine
//
//  Created by 김지연 on 12/8/23.
//

import Foundation
import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    private init() { }
    private let disposeBag = DisposeBag()
    let retryDelay: TimeInterval = 1
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(BaseURL.testURL) == true
        else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue(UserDefaultsHelper.token, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입", error)
        guard let response = request.task?.response as? HTTPURLResponse
        else {
            print("error&&&& ", error)
            
            completion(.doNotRetry)
            return
        }
        
        guard let tokenError = TokenError(rawValue: response.statusCode) else {
            completion(.doNotRetry)
            return
        }
        
        print("refresh request")
        
        TokenManager.shared.request()
            .debug()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success: 
                    print("@@success refresh intercepter@@")
                    completion(.retryWithDelay(self.retryDelay))
                case .login:
                    print("@@error refresh intercepter request login@@")
                    completion(.doNotRetryWithError(error))
                case .error: 
                    print("@@error refresh intercepter request login@@")
                    completion(.doNotRetry)
                }
            }
            .disposed(by: disposeBag)
        

    }
    
    func getNewToken(completion: @escaping (Bool) -> Void) {
        TokenManager.shared.request()
            .debug()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    print("@@success refresh intercepter@@")
                    completion(true)
                case .login, .error:
                    print("@@error refresh intercepter request login@@")
                    completion(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}


