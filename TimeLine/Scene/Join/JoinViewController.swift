//
//  JoinViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit

final class JoinViewController: BaseViewController {
    
    private let mainView = JoinView()
    private let viewModel = JoinViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        testData()
    }
    
    func testData() {
        mainView.emailTextField.text = "qq@q.com"
        mainView.passwordTextField.text = "1234"
        mainView.nicknameTextField.text = "testnick"
        mainView.birthdayTextField.text = "1999.02.24"
    }
    
    override func configure() {
        super.configure()
        mainView.datePickerview.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
    }
    
    @objc private func dateChange(_ sender: UIDatePicker) {
        mainView.birthdayTextField.text = DateFormatter.convertTextFieldDate(date: sender.date)
    }
    
    
    
}
