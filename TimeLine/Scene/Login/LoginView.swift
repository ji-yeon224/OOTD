//
//  LoginView.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

final class LoginView: BaseView {
    
    
    let emailTextField = CustomTextField(placeholder: "이메일을 입력하세요")
    
    let passwordTextField = CustomTextField(placeholder: "비밀번호를 입력하세요")
    
    private let emailUnderLineView = TextFieldUnderline()
    private let passwordUnderLineView = TextFieldUnderline()
    
    let loginButton = MainButton(title: "로그인")
    let signUpButton = {
        let view = UIButton()
        view.setTitle("회원가입", for: .normal)
        view.backgroundColor = Constants.Color.background
        view.setTitleColor(Constants.Color.basicText, for: .normal)
        return view
    }()
    
    override func configure() {
        super.configure()
        
        [emailTextField, emailUnderLineView, passwordTextField, passwordUnderLineView, loginButton, signUpButton].forEach {
            addSubview($0)
        }
        
        
    }
    
    override func setConstraints() {
        
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
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
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
    }
    
}

