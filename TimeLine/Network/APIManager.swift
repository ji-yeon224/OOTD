//
//  APIManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

final class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    let provider = MoyaProvider<SeSACAPI>()
    
    
    func request<T: Codable>(api: SeSACAPI, successType: T.Type) -> Single<Result<T, Error>> {
        
        return Single.create { single in
            self.provider.request(api) { response in
                
                switch response {
                case .success(let data):
                    let statusCode = data.statusCode
                    if statusCode == 200 {
                        let result = try! JSONDecoder().decode(T.self, from: data.data)
                        single(.success(.success(result)))
                    } else {
                        let result = try! JSONDecoder().decode(ErrorModel.self, from: data.data)
                        let error = NSError(domain: result.message, code: statusCode)
                        single(.success(.failure(error)))
                       
                    }
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                    
                }
            }
            return Disposables.create()
        }
        
    }
        
    
    
   
    
    
}
