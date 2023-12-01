//
//  BoardReadViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/23/23.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardReadViewController: BaseViewController {
    
    let mainView = BoardCollectionView()
    let disposeBag = DisposeBag()
    
    var postData: Post?
    var imageList: [UIImage] = []
    
    
    let deviceWidth = UIScreen.main.bounds.size.width
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = postData else {
            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refeshHeader), name: .reloadHeader, object: nil)
        
        mainView.postData = post
        
        var urls: [String] = []
        post.image.forEach {
            urls.append(BaseURL.baseURL + "/" + $0)
        }
        mainView.imageURL = urls
        updateSnapShot()
        
    }
    
    @objc private func refeshHeader() {
        updateSnapShot()
    }
    
    private func configData() {
        
    }
    
    private func updateSnapShot() {
//        print("update")
        var snapShot = NSDiffableDataSourceSnapshot<Int, CommentModel>()
        snapShot.appendSections([0])
        snapShot.appendItems(dummyComment)
        mainView.dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    
    
}
