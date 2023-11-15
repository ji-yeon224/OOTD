//
//  JoinView.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit

final class JoinView: BaseView {
    
   
    
    let emailTextField = CustomTextField(placeholder: "이메일을 입력하세요")
    let passwordTextField = CustomTextField(placeholder: "비밀번호를 입력하세요")
    let nicknameTextField = CustomTextField(placeholder: "닉네임을 입력하세요")
    lazy var birthdayTextField = {
        let view = CustomTextField(placeholder: "생일을 입력하세요")
        view.delegate = self
        view.inputView = datePickerview
        view.tintColor = .clear
        return view
    }()
    
    let datePickerview = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .inline
        view.backgroundColor = Constants.Color.background
        view.locale = Locale(identifier: "ko_KR")
        view.tintColor = Constants.Color.mainColor
        view.maximumDate = Date()
        
        return view
    }()
    
    let emailValidationImage = {
        let view = UIImageView()
        view.image = Constants.Image.check
        view.tintColor = Constants.Color.placeholder
        view.backgroundColor = Constants.Color.background
        return view
    }()
    
    let joinButton = MainButton(title: "회원가입")
    
    private let emailUnderLineView = TextFieldUnderline()
    private let passwordUnderLineView = TextFieldUnderline()
    private let nicknameUnderLineView = TextFieldUnderline()
    private let birthdayUnderLineView = TextFieldUnderline()
    
    override func configure() {
        super.configure()
        
        
        [emailTextField, emailValidationImage, emailUnderLineView, passwordTextField, passwordUnderLineView, nicknameTextField, nicknameUnderLineView, birthdayTextField, birthdayUnderLineView, joinButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailValidationImage.snp.makeConstraints { make in
            
            make.centerY.equalTo(emailTextField)
            make.size.equalTo(28)
//            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.trailing.equalTo(emailTextField.snp.trailing).offset(-10)
        }
        
        emailUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(emailTextField.snp.bottom)
            make.width.equalTo(emailTextField.snp.width)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passwordUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.width.equalTo(passwordTextField.snp.width)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nicknameUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.width.equalTo(nicknameTextField.snp.width)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        birthdayUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(birthdayTextField.snp.bottom)
            make.width.equalTo(birthdayTextField.snp.width)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        joinButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthdayTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        
       
    }
    
}

extension JoinView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
