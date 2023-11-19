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
        bind()
    }
    
  
    
    override func configure() {
        super.configure()
        mainView.datePickerview.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.back, style: .plain, target: self, action: #selector(backButtonTap))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.mainColor
    }
    
    @objc private func backButtonTap() {
        dismiss(animated: true)
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
                owner.showOKAlert(title: "회원 가입이 완료되었습니다.", message: "") {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, error in
                owner.mainView.joinErrorLable.text = error
                owner.mainView.joinErrorLable.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.emailValid
            .bind(with: self) { owner, value in
                let color = value ? Constants.Color.valid : Constants.Color.invalid
                owner.mainView.emailValidationImage.tintColor = color
                owner.mainView.emailValidLabel.isHidden = value
                
            }
            .disposed(by: disposeBag)
        
        output.emailValidMsg
            .bind(to: mainView.emailValidLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        output.joinValidation
            .bind(with: self) { owner, value in
                
                owner.mainView.joinButton.backgroundColor = value ? Constants.Color.mainColor : Constants.Color.disableTint
            }
            .disposed(by: disposeBag)
        
        output.passValid
            .bind(with: self) { owner, value in
                owner.mainView.passValidLabel.isHidden = value
                owner.mainView.passValidLabel.text = "비밀번호는 4글자 이상 8글자 이상으로 작성해주세요."
            }
            .disposed(by: disposeBag)
        
        output.nickValid
            .bind(with: self) { owner, value in
                owner.mainView.nickValidLabel.isHidden = value
                owner.mainView.nickValidLabel.text = "닉네입은 2글자 이상 8글자 이상으로 작성해주세요."
            }
            .disposed(by: disposeBag)
        
        output.birthValid
            .bind(with: self) { owner, value in
                print(value)
                owner.mainView.birthValidLabel.isHidden = value
                owner.mainView.birthValidLabel.text = "만 14세 이상 부터 가입 가능합니다."
            }
            .disposed(by: disposeBag)
        
    }
    
    
    @objc private func dateChange(_ sender: UIDatePicker) {
        mainView.birthdayTextField.text = DateFormatter.convertDate(date: sender.date)
    }
    
    
    
}
