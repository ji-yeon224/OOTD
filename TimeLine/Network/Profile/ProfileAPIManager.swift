//
//  ProfileAPIManager.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import Foundation
import Moya
import RxSwift

final class ProfileAPIManager {
    static let shared = ProfileAPIManager()
    private init() { }
    private let provider = MoyaProvider<ProfileAPI>(session: Session(interceptor: AuthInterceptor.shared))
    
    func request<T: Decodable>(api: ProfileAPI, type: T.Type) -> Single<Result<T, NetworkError>> {
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(T.self, from: response.data)
                            single(.success(.success(result)))
                        } catch {
                            single(.success(.failure(NetworkError(statusCode: 500, description: "문제가 발생하였습니다."))))
                        }
                    } else {
                        single(.success(.failure(NetworkError(statusCode: statusCode, description: ""))))
                    }
                case .failure(let error):
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
