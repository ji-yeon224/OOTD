//
//  BoardViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardViewModel {
    
    var data: [Post] = []
    private var nextCursor: String? = nil
   
    
    let disposeBag = DisposeBag()
    
    struct Input {
//        let refresh: PublishRelay<Bool>
        let page: ControlEvent<[IndexPath]>
        let callFirst: PublishRelay<Bool>
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
        let errorMsg: PublishSubject<String>
        let tokenRequest: PublishSubject<RefreshResult>
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        let errorMsg: PublishSubject<String> = PublishSubject()
        let tokenRequest = PublishSubject<RefreshResult>()
        let refresh = PublishRelay<Bool>()
        
        input.callFirst
            .bind(with: self) { owner, value in
                if value {
                    print("refreshss")
                    owner.data.removeAll()
                    owner.nextCursor = nil
                }
                refresh.accept(true)
            }
            .disposed(by: disposeBag)
        
        refresh
            .flatMap {_ in
                return PostAPIManager.shared.request(api: .read(productId: ProductId.OOTDBoard.rawValue, limit: 10, next: self.nextCursor), type: ReadResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    
                    owner.nextCursor = result.nextCursor
                    owner.data.append(contentsOf: result.data)
                    items.accept([PostListModel(section: "", items: owner.data)])
                    
                case .failure(let error):
                    let code = error.statusCode
                    guard let errorType = PostReadError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        return
                    }
                    debugPrint("[DEBUG-POST] ", error.statusCode, error.description)
                    switch errorType {
                    case .invalidRequest:
                        errorMsg.onNext(errorType.localizedDescription)
                    case .wrongAuth, .forbidden, .expireToken:
                        let result = RefreshTokenManager.shared.tokenRequest()
                        
                        result
                            .bind(with: self) { owner, result in
                                if result == .success {
                                    input.callFirst.accept(true)
                                } else {
                                    tokenRequest.onNext(result)
                                }
                            }
                            .disposed(by: owner.disposeBag)
                    
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.page
            .compactMap(\.last?.row)
            .withUnretained(self)
            .bind(with: self) { owner, row in
                //print(row)
                if row.1 == owner.data.count - 1 && owner.nextCursor != "0" {
                    input.callFirst.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(items: items, errorMsg: errorMsg, tokenRequest: tokenRequest)
    }
    
}
