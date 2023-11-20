//
//  PostAPIManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation
import Moya


final class PostAPIManager {
    
    static let shared = PostAPIManager()
    private init() { }
    private let provider = MoyaProvider<PostAPI>()
    
    func request(api: PostAPI) {
        
        provider.request(api) { result in
            print(result)
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    print(response.statusCode)
                    let result = try! JSONDecoder().decode(WriteResponse.self, from: response.data)
                    debugPrint("[SUCCESS WRITE]", result)
                }
            case .failure(let error):
                print(error.response?.statusCode)
            }
        }
        
        
    }
    
}
