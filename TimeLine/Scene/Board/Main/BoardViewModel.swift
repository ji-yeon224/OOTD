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
    
    let item = [
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id", creator: Creator(id: "creat", nick: "nick"), time: "time", title: "titleeeeeeeeeeeeeeeeeeeehhffgffffffffffffeeeeeeee", content: "content", productID: "productid"),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id11", creator: Creator(id: "creat11", nick: "nick11"), time: "time11", title: "title11", content: "content11llllllllllllllllllllllllllllllllllll", productID: "productid"),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id22", creator: Creator(id: "creat22", nick: "nick22"), time: "time22", title: "title22", content: "content22", productID: "productid"),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id33", creator: Creator(id: "creat33", nick: "nick33"), time: "time33", title: "title33", content: "conten33t", productID: "productid")
    ]
    //let dummy = [PostListModel(section: "", items: self.item)]
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let refresh: BehaviorSubject<Bool>
        
    }
    
    struct Output {
        let items: BehaviorRelay<[PostListModel]>
        
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorRelay<[PostListModel]> = BehaviorRelay(value: [])
        
//        input.refresh
//            .bind(with: self) { owner, value in
//                items.accept([PostListModel(section: "", items: owner.item)])
//            }
//            .disposed(by: disposeBag)
        
        input.refresh
            .flatMap {_ in 
                return PostAPIManager.shared.request(api: .read(productId: ProductId.OOTDBoard.rawValue, limit: 5), type: ReadResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    owner.data.removeAll()
                    owner.data.append(contentsOf: result.data)
                    items.accept([PostListModel(section: "", items: owner.data)])
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            .disposed(by: disposeBag)
        return Output(items: items)
    }
    
}
