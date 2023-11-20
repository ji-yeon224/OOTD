//
//  PostAPIManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation
import Moya
import RxSwift

final class PostAPIManager {
    
    static let shared = PostAPIManager()
    private init() { }
    private let provider = MoyaProvider<PostAPI>()
    
    func request(api: PostAPI) -> Single<Result<WriteResponse, NetworkError>>{
        return Single.create { single in
        
            self.provider.request(api) { result in
                print(result)
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                        print(response.statusCode)
                        let result = try! JSONDecoder().decode(WriteResponse.self, from: response.data)
                        debugPrint("[SUCCESS WRITE]", result)
                        single(.success(.success(result)))
                    } else {
                        let result = try! JSONDecoder().decode(ErrorModel.self, from: response.data)
                        let error = NetworkError(statusCode: statusCode, description: result.message)
                        single(.success(.failure(error)))
                    }
                case .failure(let error):
                    let error = NetworkError(statusCode: error.errorCode, description: error.localizedDescription)
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
        
        
    }
    
}
