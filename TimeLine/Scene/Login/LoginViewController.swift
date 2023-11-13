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
    
    private func bind() {
        
        let input = LoginViewModel.Input(
            email: mainView.emailTextField.rx.text.orEmpty,
            password: mainView.passwordTextField.rx.text.orEmpty,
            buttonTap: mainView.loginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.successToken
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        

    }
    
    
    
}
