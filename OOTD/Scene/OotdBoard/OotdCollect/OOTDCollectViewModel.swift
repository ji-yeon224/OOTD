//
//  OOTDViewModel.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import Foundation
import RxSwift
import RxCocoa

final class OOTDCollectViewModel {
    
    private var nextCursor: String? = nil
    var data: [Post] = []
    var userId: String? = UserDefaultsHelper.userID
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let callFirstPage: PublishRelay<String>
        let page: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
        
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        let requestPost = PublishRelay<String?>()
        
        input.callFirstPage
            .bind(with: self) { owner, value in
                owner.data.removeAll()
                owner.nextCursor = nil
                if value.count > 0 { owner.userId = value }
                requestPost.accept(owner.nextCursor)
            }
            .disposed(by: disposeBag)
        
        requestPost
            .flatMap { next in
                PostAPIManager.shared.postrequest(api: .userPosts(id: self.userId ?? UserDefaultsHelper.userID, productId: ProductId.OOTDPhoto.rawValue, limit: 18, next: next), type: ReadResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.nextCursor = value.nextCursor
                    owner.data.append(contentsOf: value.data)
                    items.accept([PostListModel(section: "", items: owner.data)])
                case .failure(let error):
                    let code = error.statusCode
                    guard let errorType = PostReadError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                    errorMsg.accept(errorType.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.page
            .compactMap(\.last?.item)
            .withUnretained(self)
            .bind { owner, item in
                if item == owner.data.count - 1 && owner.nextCursor != "0" {
                    requestPost.accept(owner.nextCursor)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            items: items,
            errorMsg: errorMsg,
            loginRequest: loginRequest
        )
    }
    
    
}
