//
//  TestViewController.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDCollectViewController: BaseViewController {
    
    private let mainView =  OOTDCollectView()
    private let viewModel = OOTDCollectViewModel()
    private let disposeBag = DisposeBag()
    
    private let requestPost = PublishRelay<String>()
    var userId: String?
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        requestPost.accept(userId ?? UserDefaultsHelper.userID)
        
    }
    
    
    private func bind() {
        
        let input = OOTDCollectViewModel.Input(
            callFirstPage: requestPost,
            page: mainView.collectionView.rx.prefetchItems
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .bind(to: mainView.collectionView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.initToken()
                    // 로그인 뷰로 present
                    let vc = LoginViewController()
                    vc.transition = .presnt
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.completionHandler = {
                        owner.requestPost.accept(owner.userId ?? UserDefaultsHelper.userID)
                    }
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.refreshPhoto)
            .bind(with: self) { owner, _ in
                owner.requestPost.accept(UserDefaultsHelper.userID)
            }
            .disposed(by: disposeBag)
        
    }
    
}
