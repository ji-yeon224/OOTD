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
    var boardType: BoardViewType = .main
    
    let disposeBag = DisposeBag()
    
    struct Input {
//        let refresh: PublishRelay<Bool>
        let page: ControlEvent<[IndexPath]>
        let callFirst: PublishRelay<Bool>
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
        let errorMsg: PublishSubject<String>
        let loginRequest: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        let errorMsg: PublishSubject<String> = PublishSubject()
        let refresh = PublishRelay<Bool>()
        let loginRequest = PublishRelay<Bool>()
        input.callFirst
            .bind(with: self) { owner, value in
                if value {
                    owner.data.removeAll()
                    owner.nextCursor = nil
                }
//                debugPrint("[Board First Page Request]")
                refresh.accept(true)
            }
            .disposed(by: disposeBag)
        
        refresh
            .map { _ in
                switch self.boardType {
                case .main:
                    return PostAPI.read(productId: ProductId.OOTDBoard.rawValue, limit: 10, next: self.nextCursor)
                case .my:
                    return PostAPI.myLike(limit: 10, next: self.nextCursor)
                }
            }
            .flatMap { api in
                return PostAPIManager.shared.postrequest(api: api, type: ReadResponse.self)
            }
            .subscribe(with: self) { owner, response in                switch response {
                case .success(let result):
//                    debugPrint("[BoardVM Success]")
                    owner.nextCursor = result.nextCursor
                    owner.data.append(contentsOf: result.data)
                    items.accept([PostListModel(section: "", items: owner.data)])
                case .failure(let error):
                    debugPrint("[BoardVM error] ", error)
                    
                    let code = error.statusCode
                    guard let errorType = PostReadError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    errorMsg.onNext(errorType.localizedDescription)
                    
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
        
        
        return Output(items: items, errorMsg: errorMsg, loginRequest: loginRequest)
    }
    
}
