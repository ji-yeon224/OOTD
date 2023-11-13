//
//  APIManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation
import Moya
import RxSwift

final class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    let provider = MoyaProvider<SeSACAPI>()
    
    func request(api: SeSACAPI) -> Observable<LoginToken> {
        
        return Observable.create { value in
            self.provider.request(api) { response in
                
                switch response {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        let result = try! JSONDecoder().decode(LoginToken.self, from: data.data)
                        value.onNext(result)
                    } else {
                        let result = try! JSONDecoder().decode(ErrorModel.self, from: data.data)
                        value.onError(NSError(domain: result.message, code: statusCode))
                    }
                    
                case .failure(let error):
                    value.onError(error)
                    
                }
            }
            return Disposables.create()
        }
        
        
    }
    
}
