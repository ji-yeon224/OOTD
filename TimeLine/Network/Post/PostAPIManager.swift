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
    
    func request<T: Codable>(api: PostAPI, type: T.Type) -> Single<Result<T, NetworkError>>{
        return Single.create { single in
        
            self.provider.request(api) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                       
                        do {
                            let result = try JSONDecoder().decode(T.self, from: response.data)
                            debugPrint("[SUCCESS POST REQUEST]")
                            single(.success(.success(result)))
                        } catch {
                            debugPrint("[SUCCESS] DECODING ERROR", error.localizedDescription)
                        }
                        
                    } else {
                        do {
                            let result = try JSONDecoder().decode(ErrorModel.self, from: response.data)
                            let error = NetworkError(statusCode: statusCode, description: result.message)
                            single(.success(.failure(error)))
                        } catch {
                            debugPrint("DECODING ERROR", error.localizedDescription)
                        }
                        
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
