//
//  OOTDViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import Foundation
import RxSwift
import RxCocoa

final class OOTDViewModel {
    
    private var nextCursor: String? = nil
    var data: [Post] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let callFirstPage: PublishRelay<Bool>
        let page: ControlEvent<[IndexPath]>
        let deleteRequest: PublishRelay<(String, Int)>
        let likeButton: PublishRelay<String>
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
        let errorMsg: PublishRelay<String>
        let loginRequest: PublishRelay<Bool>
        let successDelete: PublishRelay<Bool>
        let likeSuccess: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        let errorMsg = PublishRelay<String>()
        let loginRequest = PublishRelay<Bool>()
        let requestPost = PublishRelay<String?>()
        let successDelete = PublishRelay<Bool>()
        let likeSuccess = PublishRelay<Bool>()
        
        var idx: Int?
        
        input.callFirstPage
            .bind(with: self) { owner, value in
                owner.data.removeAll()
                owner.nextCursor = nil
                requestPost.accept(owner.nextCursor)
            }
            .disposed(by: disposeBag)
        
        requestPost
            .flatMap { next in
                PostAPIManager.shared.postrequest(api: .read(productId: ProductId.OOTDPhoto.rawValue, limit: 5, next: next), type: ReadResponse.self)
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
        
        input.deleteRequest
            .map {
                idx = $0.1
                return $0.0
            }
            .flatMap {
                PostAPIManager.shared.postrequest(api: .delete(id: $0), type: DeleteResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    debugPrint("[DELETE POST SUCCESS]")
                    successDelete.accept(true)
                    if let idx = idx {
                        owner.data.remove(at: idx)
                        items.accept([PostListModel(section: "", items: owner.data)])
                    } else {
                        input.callFirstPage.accept(true)
                    }
                    
                case .failure(let error):
                    let code = error.statusCode
                    guard let errorType = PostDeleteError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        return
                    }
                    debugPrint("[DEBUG-POST] ", error.statusCode, error.description)
                    errorMsg.accept(errorType.localizedDescription)
                    
                    
                }
            }
            .disposed(by: disposeBag)
        
        input.likeButton
            .flatMap {
                PostAPIManager.shared.postrequest(api: .like(id: $0), type: LikeResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    print("success")
                    likeSuccess.accept(true)
                case .failure(let error):
                    let code = error.statusCode
                    likeSuccess.accept(false)
                    guard let _ = LikeError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            errorMsg.accept(commonError.localizedDescription)
                        }
                        loginRequest.accept(true)
                        return
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            items: items,
            errorMsg: errorMsg,
            loginRequest: loginRequest,
            successDelete: successDelete,
            likeSuccess: likeSuccess
        )
        
    }
    
    
    
}

