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
        print(String(describing: UserDefaultsHelper.shared.token))
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
                    owner.showOKAlert(title: "문제가 발생하였습니다. 재로그인 후 다시 요청해주세요.", message: "") {
                        UserDefaultsHelper.shared.isLogin = false
                        // 로그인 뷰로 present
                        owner.view?.window?.rootViewController = LoginViewController()
                        owner.view.window?.makeKeyAndVisible()
                    }
                case .error:
                    owner.showOKAlert(title: "요청을 처리하지 못하였습니다. 다시 시도해주세요.", message: "") { }
                case .success:
                    break
                    
                }
            }
            .disposed(by: disposeBag)
        output.withdraw
            .bind(with: self) { owner, value in
                if value {
                    owner.showOKAlert(title: "탈퇴가 완료되었습니다.", message: "") {
                        UserDefaultsHelper.shared.isLogin = false
                        // 로그인 뷰로 present
                        owner.view?.window?.rootViewController = LoginViewController()
                        owner.view.window?.makeKeyAndVisible()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    
}
