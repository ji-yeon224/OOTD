//
//  UpdateProfileViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class UpdateProfileViewController: BaseViewController {
    
    private let mainView = UpdateProfileView()
    
    init(nick: String, image: String?) {
        super.init(nibName: nil, bundle: nil)
        mainView.nickNameTextField.text = nick
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
        configNavBar()
    }
    
    
    
}


extension UpdateProfileViewController {
    
    private func configNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.back, style: .plain, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(updateButton))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
        title = "프로필 수정"
    }
    
    @objc private func updateButton() {
        view.endEditing(true)
        
    }
    
    @objc private func backButton() {
        navigationController?.popViewController(animated: true)
    }
    
}
