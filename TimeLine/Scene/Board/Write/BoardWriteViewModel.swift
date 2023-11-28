//
//  BoardWriteViewModel.swift
//  TimeLine
//
//  Created by 김지연 on 11/20/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardWriteViewModel {
    
    private let disposeBag = DisposeBag()
    private var imageModel = SelectImageModel(section: "", items: [])
    private lazy var imageSectionModel: PublishRelay<[SelectImageModel]> = PublishRelay()
    
    struct Input {
        let postButton: PublishRelay<Bool>
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let imageDelete: PublishRelay<Int>
    }
    
    struct Output {
        let postButtonEnabled: Observable<Bool>
        let tokenRequest: PublishSubject<RefreshResult>
        let items: PublishRelay<[SelectImageModel]>
    }
    
    
    func trasform(input: Input) -> Output {
        
        var titleStr = ""
        var contentStr = ""
        
        
        let postEvent = PublishRelay<Bool>()
        let tokenRequest = PublishSubject<RefreshResult>()
        
        
        let validation = Observable.combineLatest(input.titleText, input.contentText) { title, content in
            titleStr = title.trimmingCharacters(in: .whitespaces)
            contentStr = content.trimmingCharacters(in: .whitespaces)
            return titleStr.count > 0 && contentStr.count > 0
        }
        
        input.postButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                postEvent.accept(value)
            }
            .disposed(by: disposeBag)
       
        
        postEvent
            .map { _ in
                self.imageToData()
            }
            .flatMap { value in
                PostAPIManager.shared.request(api: .write(data: PostWrite(title: titleStr, content: contentStr, file: value, product_id: ProductId.OOTDBoard.rawValue)), type: Post.self)
            }
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    print("[SUCCESS] ",data)
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = ContentError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
                            print(commonError.localizedDescription)
                        }
                        return
                    }
                    switch errorType {
                    case .invalidToken, .expireToken:
                        let result = RefreshTokenManager.shared.tokenRequest()
                        result
                            .bind(with: self, onNext: { owner, result in
                                debugPrint("[TOKEN 재발급]", String(describing: UserDefaultsHelper.token))
                                switch result {
                                case .success:
                                    postEvent.accept(true)
                                case .login, .error:
                                    tokenRequest.onNext(result)
                                }
                            })
                            .disposed(by: owner.disposeBag)
                    case .forbidden:
                        tokenRequest.onNext(RefreshResult.login)
                   
                    }
                    
                }
            })
            .disposed(by: disposeBag)
       
        input.imageDelete
            .bind(with: self) { owner, index in
                owner.imageModel.items.remove(at: index)
                owner.imageSectionModel.accept([owner.imageModel])
                
            }
            .disposed(by: disposeBag)
        
        return Output(postButtonEnabled: validation, tokenRequest: tokenRequest, items: imageSectionModel)
    }
    
    private func imageToData() -> [Data] {
        var imgData: [Data] = []
        
        imageModel.items.forEach {
            guard let data = $0.image.jpegData(compressionQuality: 0.5) else { return }
            imgData.append(data)
        }
        
        return imgData
        
        
    }
    
    func setImageItems(_ items: [SelectedImage]) {
        imageModel.items.append(contentsOf: items)
        imageSectionModel.accept([imageModel])
    }
    
    
    
}
