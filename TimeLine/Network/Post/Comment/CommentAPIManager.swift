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
                    break
                case .failure(let error):
                    break
                }
            }
            return Disposables.create()
        }
    }
    
}
