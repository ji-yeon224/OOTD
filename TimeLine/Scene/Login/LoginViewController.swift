//
//  LoginViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    let emailText = BehaviorRelay(value: "")
    let passText = BehaviorRelay(value: "")
    
    override func loadView() {
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.emailTextField.text = ""
        mainView.passwordTextField.text = ""
        mainView.errorLabel.isHidden = true
    }
    
    private func bind() {
        
        let input = LoginViewModel.Input(
            email: mainView.emailTextField.rx.text.orEmpty,
            password: mainView.passwordTextField.rx.text.orEmpty,
            buttonTap: mainView.loginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.errorMsg
            .bind(with: self) { owner, error in
                owner.mainView.errorLabel.text = error
                owner.mainView.errorLabel.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.success
            .bind(with: self) { owner, value in
                if value {
                    print("Login Success")
                    UserDefaultsHelper.shared.isLogin = true
                    owner.view?.window?.rootViewController = HomeViewController()
                    owner.view.window?.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                owner.mainView.loginButton.backgroundColor = value ? Constants.Color.mainColor : Constants.Color.disableTint
            }
            .disposed(by: disposeBag)
        
        
        mainView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(JoinViewController(), animated: true)
                    
            }
            .disposed(by: disposeBag)
        

    }
    
    
    
}
