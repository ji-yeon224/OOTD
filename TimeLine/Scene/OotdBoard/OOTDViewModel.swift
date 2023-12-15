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
    
    lazy var model = [PostListModel(section: "", items: dummy)]
    private let disposeBag = DisposeBag()
    
    let dummy: [Post] = [
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id1", creator: Creator(id: "id1", nick: "test1", profile: nil), time: "", title: "", content: "content11", productID: ""),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id2", creator: Creator(id: "id2", nick: "test2", profile: nil), time: "", title: "", content: "content22", productID: ""),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id3", creator: Creator(id: "id3", nick: "test3", profile: nil), time: "", title: "", content: "content33", productID: "")
        
    
    ]
    
    struct Input {
        let requestPost: BehaviorRelay<Bool>
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
    }
    
    func transform(input: Input) -> Output {
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        input.requestPost
            .map { _ in
                return self.model
            }
            .bind(with: self) { owner, value in
                print(value[0].items.count)
                items.accept([PostListModel(section: "", items: owner.dummy)])
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(
            items: items
        )
        
    }
    
    
    
}

