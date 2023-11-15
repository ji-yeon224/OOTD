//
//  JoinViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class JoinViewController: BaseViewController {
    
    private let mainView = JoinView()
    private let viewModel = JoinViewModel()
    
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        testData()
        bind()
    }
    
    private func testData() {
        mainView.emailTextField.text = "qq@q.com"
        mainView.passwordTextField.text = "1234"
        mainView.nicknameTextField.text = "testnick"
        mainView.birthdayTextField.text = "1999.02.24"
    }
    
    override func configure() {
        super.configure()
        mainView.datePickerview.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
    }
    
    
    private func bind() {
        
        let input = JoinViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            passText: mainView.passwordTextField.rx.text.orEmpty,
            nickText: mainView.nicknameTextField.rx.text.orEmpty,
            birthText: mainView.birthdayTextField.rx.text.orEmpty,
            buttonTap: mainView.joinButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.joinCompleted
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        output.emailValidation
            .bind(with: self) { owner, value in
                owner.mainView.emailValidationImage.tintColor = value ? Constants.Color.valid : Constants.Color.invalid
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    @objc private func dateChange(_ sender: UIDatePicker) {
        mainView.birthdayTextField.text = DateFormatter.convertDate(date: sender.date)
    }
    
    
    
}
