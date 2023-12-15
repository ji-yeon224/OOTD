//
//  OOTDViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDViewController: BaseViewController {
    
    private let mainView = OOTDView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        super.configure()
        
    }
    
    private func bind() {
        
        Observable.just(model)
            .bind(to:  mainView.collectionView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
       
        
    }
    
    lazy var model = [PostListModel(section: "", items: self.dummy)]
    
    let dummy = [
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id1", creator: Creator(id: "id1", nick: "test1", profile: nil), time: "", title: "", content: "content11", productID: ""),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id2", creator: Creator(id: "id2", nick: "test2", profile: nil), time: "", title: "", content: "content22", productID: ""),
        Post(likes: [], image: [], hashTags: [], comments: [], id: "id3", creator: Creator(id: "id3", nick: "test3", profile: nil), time: "", title: "", content: "content33", productID: "")
        
    
    ]
    
}
