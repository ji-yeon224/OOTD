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
    private let provider = MoyaProvider<PostAPI>(session: Session(interceptor: AuthInterceptor.shared))
    
   
    func postrequest<T: Decodable>(api: PostAPI, type: T.Type) -> Single<Result<T, NetworkError>> {
        return Single.create { single in
            self.provider.request(api) { result in
//                print("PostAPIManager response ", result)
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                        
                        do {
                            
                            let result = try JSONDecoder().decode(T.self, from: response.data)
                            debugPrint("[SUCCESS POST REQUEST]")
                            single(.success(.success(result)))
                        } catch {
                            debugPrint("[POST(request success)] DECODING ERROR", error)
                            
                        }
                        
                    }
//                    single(.success(.success(response)))
                case .failure(let error):
                    print("error")
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
