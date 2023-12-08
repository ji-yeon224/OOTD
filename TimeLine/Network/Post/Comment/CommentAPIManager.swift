//
//  CommentAPIManager.swift
//  TimeLine
//
//  Created by 김지연 on 12/7/23.
//

import Foundation
import Moya
import RxSwift

final class CommentAPIManager {
    
    static let shared = CommentAPIManager()
    private init() { }
    private let provider = MoyaProvider<CommentAPI>()
    
    func request<T: Codable>(api: CommentAPI, type: T.Type) -> Single<Result<T, NetworkError>>{
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(T.self, from: response.data)
                            debugPrint("[SUCCESS COMMENT REQUEST]", result)
                            single(.success(.success(result)))
                        } catch {
                            debugPrint("[COMMENT DECODING ERROR] ", error)
                        }
                    } else {
                        do {
                            let result = try JSONDecoder().decode(ErrorModel.self, from: response.data)
                            let error = NetworkError(statusCode: statusCode, description: result.message)
                            single(.success(.failure(error)))
                        } catch {
                            debugPrint("[COMMENT DECODING ERROR ]", error.localizedDescription)
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
