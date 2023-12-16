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
    private let retryDelay: TimeInterval = 0.5
    private let retryLimit = 2
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(BaseURL.baseURL) == true
        else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue(UserDefaultsHelper.token, forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
       
        
        
        guard let response = request.task?.response as? HTTPURLResponse, request.retryCount < self.retryLimit
        else {
            
            completion(.doNotRetry)
            return
        }
        
        guard let _ = TokenError(rawValue: response.statusCode) else {
            let error = NetworkError(statusCode: response.statusCode, description: error.localizedDescription)
            
            completion(.doNotRetryWithError(error))
            return
        }

        print(request.response?.headers)
        debugPrint("[refresh request: \(response.statusCode)]")
        
        TokenManager.shared.request()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let token):
                    debugPrint("[SUCCESS REFRESH TOKEN]")
                    UserDefaultsHelper.token = token
                    completion(.retryWithDelay(self.retryDelay))
                    
                case .login(let error):
                    debugPrint("[ERROR REFRESH TOKEN - REQUEST LOGIN]")
                    completion(.doNotRetryWithError(error))
                case .error: 
                    debugPrint("[ERROR REFRESH TOKEN]")
                    completion(.doNotRetry)
                }
            }
            .disposed(by: disposeBag)
        

    }

    
    
    
}


