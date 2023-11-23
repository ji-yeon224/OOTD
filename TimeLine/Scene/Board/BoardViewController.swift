//
//  BoardViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class BoardViewController: BaseViewController {
    
    private let mainView = BoardView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    private func bind() {
        mainView.writeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = BoardWriteViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        
        
        PostAPIManager.shared.request(api: .read(productId: ProductId.OOTDBoard.rawValue, limit: 5), type: ReadResponse.self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    
                    let data = result.data[0]
                    owner.mainView.titleLabel.text = data.title
                    
                    let imgURL = BaseURL.baseURL+"/"+data.image[0]
                    let url = URL(string:imgURL)
                    
                    owner.mainView.imageView.kf.setImage(with: url, options: [.requestModifier(ImageLoadManager.shared.getModifier())])
                    

                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
