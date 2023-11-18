//
//  JoinView.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit

final class JoinView: BaseView {
    
    private let emailView = UIView()
    private let passView = UIView()
    private let nickView = UIView()
    private let birthView = UIView()
    
    private let emailStack = ValidStackView()
    private let passStack = ValidStackView()
    private let nickStack = ValidStackView()
    private let birthStack = ValidStackView()
    
    
    let emailValidLabel = ValidationLabel()
    let passValidLabel = ValidationLabel()
    let nickValidLabel = ValidationLabel()
    
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
        view.date = DateFormatter.stringToDate(date: "1999.02.24")
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
    let joinErrorLable = ValidationLabel()
    
    private lazy var joinStack = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.addArrangedSubview(self.joinErrorLable)
        view.addArrangedSubview(self.joinButton)
        return view
    }()
    
    private let emailUnderLineView = TextFieldUnderline()
    private let passwordUnderLineView = TextFieldUnderline()
    private let nicknameUnderLineView = TextFieldUnderline()
    private let birthdayUnderLineView = TextFieldUnderline()
    
    override func configure() {
        super.configure()
        
        setStackViewConstraints()
        
        
        [emailStack, passStack, nickStack, birthdayTextField, birthdayUnderLineView, joinStack].forEach {
            addSubview($0)
        }
    }
    
    private func setStackViewConstraints() {
        emailView.addSubview(emailTextField)
        emailView.addSubview(emailUnderLineView)
        emailView.addSubview(emailValidationImage)
        
        passView.addSubview(passwordTextField)
        passView.addSubview(passwordUnderLineView)
        
        nickView.addSubview(nicknameTextField)
        nickView.addSubview(nicknameUnderLineView)
        
        emailStack.addArrangedSubview(emailView)
        emailStack.addArrangedSubview(emailValidLabel)
        
        passStack.addArrangedSubview(passView)
        passStack.addArrangedSubview(passValidLabel)
        
        nickStack.addArrangedSubview(nickView)
        nickStack.addArrangedSubview(nickValidLabel)
        
        
    }
    
    override func setConstraints() {
        
        emailStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(emailUnderLineView.snp.top)
            make.top.equalTo(emailView.snp.top)
            make.horizontalEdges.equalTo(emailView)
        }
        
        emailValidationImage.snp.makeConstraints { make in
            
            make.centerY.equalTo(emailTextField)
            make.size.equalTo(28)
            make.trailing.equalTo(emailTextField.snp.trailing).offset(-10)
        }
        
        emailUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(emailView.snp.bottom)
            make.horizontalEdges.equalTo(emailView)
        }
        
        emailValidLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        passStack.snp.makeConstraints { make in
            make.top.equalTo(emailStack.snp.bottom).offset(25)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            
            make.bottom.equalTo(passwordUnderLineView.snp.top)
            make.top.equalTo(passView.snp.top)
            make.horizontalEdges.equalTo(passView)
            
        }
        
        passwordUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(passView.snp.bottom)
            make.horizontalEdges.equalTo(passView)
        }
        
        passValidLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        nickStack.snp.makeConstraints { make in
            make.top.equalTo(passStack.snp.bottom).offset(25)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nickView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(nicknameUnderLineView.snp.top)
            make.top.equalTo(nickView.snp.top)
            make.horizontalEdges.equalTo(nickView)
            
        }
        
        nicknameUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(nickView.snp.bottom)
            make.horizontalEdges.equalTo(nickView)
        }
        
        nickValidLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nickStack.snp.bottom).offset(25)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        birthdayUnderLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(birthdayTextField.snp.bottom)
            make.width.equalTo(birthdayTextField.snp.width)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        
        
        joinStack.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        joinButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        joinErrorLable.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        
       
    }
    
}

extension JoinView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
