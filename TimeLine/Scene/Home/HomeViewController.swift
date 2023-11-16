//
//  HomeViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    private let mainView = HomeView()
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = HomeViewModel.Input(
            contentButtonTap: mainView.contentButton.rx.tap,
            withdrawButtonTap: mainView.withdrawButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        mainView.logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                UserDefaultsHelper.shared.isLogin = false
                owner.view?.window?.rootViewController = LoginViewController()
                owner.view.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                print("ERROR ", value)
            }
            .disposed(by: disposeBag)
        
        output.successMsg
            .bind(with: self) { owner, value in
                print("SUCCESS - 게시글 작성")
            }
            .disposed(by: disposeBag)
        
        output.tokenRequest
            .bind(with: self) { owner, value in
                switch value {
                case .login:
                    UserDefaultsHelper.shared.isLogin = false
                    owner.view?.window?.rootViewController = LoginViewController()
                    owner.view.window?.makeKeyAndVisible()
                case .retry:
                    debugPrint("서버 에러 - 재시도 요청")
                case .success:
                    debugPrint("토큰 재발급 완료")
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
    
    
}
