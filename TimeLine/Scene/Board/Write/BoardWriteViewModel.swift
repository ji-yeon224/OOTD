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
    private let maxSelectCount = 3
    var selectCount = 3
    var postID: String?
    
    struct Input {
        let postButton: PublishRelay<BoardMode>
        let updateButton: PublishRelay<Bool>
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let imageDelete: PublishRelay<Int>
    }
    
    struct Output {
        let errorMsg: PublishSubject<String>
        let postButtonEnabled: Observable<Bool>
        let tokenRequest: PublishSubject<RefreshResult>
        let items: PublishRelay<[SelectImageModel]>
        let enableAddImage: BehaviorRelay<Bool>
        let successPost: PublishRelay<(Bool, String, Post?)>
    }
    
    
    func trasform(input: Input) -> Output {
        
        var titleStr = ""
        var contentStr = ""
        
        let errorMsg: PublishSubject<String> = PublishSubject()
        let postEvent = PublishRelay<Bool>()
        let updateEvent = PublishRelay<Bool>()
        let tokenRequest = PublishSubject<RefreshResult>()
        let enableAddImage = BehaviorRelay(value: true)
        let successPost = PublishRelay<(Bool, String, Post?)>()
        
        
        let validation = Observable.combineLatest(input.titleText, input.contentText) { title, content in
            titleStr = title.trimmingCharacters(in: .whitespaces)
            contentStr = content.trimmingCharacters(in: .whitespaces)
            return titleStr.count > 0 && contentStr.count > 0
        }
        
        input.postButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                switch value {
                case .edit:
                    updateEvent.accept(true)
                case .add:
                    postEvent.accept(true)
                }
                
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
                    successPost.accept((true, "success", data))
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = PostWriteError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
//                            print(commonError.localizedDescription)
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        return
                    }
                    switch errorType {
                    case .wrongAuth, .expireToken:
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
                        let error = NetworkError(statusCode: code, description: errorType.localizedDescription)
                        tokenRequest.onNext(RefreshResult.login(error: error))
                    case .invalidRequest, .saveError:
                        errorMsg.onNext(errorType.localizedDescription)
                        successPost.accept((false, errorType.localizedDescription, nil))
                    }
                    
                }
            })
            .disposed(by: disposeBag)
        
        updateEvent
            .flatMap { _ in
                PostAPIManager.shared.request(api: .update(id: self.postID ?? "-1", data: PostWrite(title: titleStr, content: contentStr, file: self.imageToData(), product_id: ProductId.OOTDBoard.rawValue)), type: Post.self)
            }
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    print("[SUCCESS] ",data)
                    successPost.accept((true, "success", data))
                case .failure(let error):
                    let code = error.statusCode
                    
                    guard let errorType = PostUpdateError(rawValue: code) else {
                        if let commonError = CommonError(rawValue: code) {
//                            print(commonError.localizedDescription)
                            errorMsg.onNext(commonError.localizedDescription)
                        }
                        return
                    }
                    switch errorType {
                    case .wrongAuth, .expireToken:
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
                        let error = NetworkError(statusCode: code, description: errorType.localizedDescription)
                        tokenRequest.onNext(RefreshResult.login(error: error))
                    case .invalidRequest, .noAuthorization, .alreadyDelete:
                        errorMsg.onNext(errorType.localizedDescription)
                        successPost.accept((false, errorType.localizedDescription, nil))
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
        
        imageSectionModel
            .bind(with: self) { owner, value in
                owner.selectCount = owner.maxSelectCount - value[0].items.count
                enableAddImage.accept(owner.selectCount > 0)
            }
            .disposed(by: disposeBag)
        
        return Output(errorMsg: errorMsg, postButtonEnabled: validation, tokenRequest: tokenRequest, items: imageSectionModel, enableAddImage: enableAddImage, successPost: successPost)
    }
    
    private func imageToData() -> [Data] {
        var imgData: [Data] = []
        let destSize = 1 * 1000 * 1000
        let compression = Compression.allCases.sorted(by: { $0.rawValue > $1.rawValue })
        imageModel.items.forEach {
            
            var image = $0.image
            if image.size.width > 700 || image.size.height > 700 {
                image = image.resize(size: 700)
            }
            
            for value in compression {
                guard let data = image.jpegData(compressionQuality: value.rawValue) else { return }
//                print(data.count, value.rawValue)
                if data.count < destSize {
                    print(data.count, value.rawValue)
                    imgData.append(data)
                    break
                }
            }
        }
        
        return imgData
        
        
    }
    
    func setImageItems(_ items: [SelectedImage]) {
        imageModel.items.append(contentsOf: items)
        imageSectionModel.accept([imageModel])
        
    }
    
    
}

private enum Compression: CGFloat, CaseIterable {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}
