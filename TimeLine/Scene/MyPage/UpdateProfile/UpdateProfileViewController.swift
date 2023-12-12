//
//  UpdateProfileViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxSwift
import RxCocoa

final class UpdateProfileViewController: BaseViewController {
    
    private let mainView = UpdateProfileView()
    private let viewModel = UpdateProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private let nicknameTextField = PublishRelay<String>()
    
    private var nickname: String?
    private var profile: String?
    
    init(nick: String, image: String?) {
        super.init(nibName: nil, bundle: nil)
        mainView.nickNameTextField.text = nick
        nickname = nick
        profile = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func configure() {
        super.configure()
        
        configNavBar()
        
        
        
    }
    
    private func bind() {
        
        
        let input = UpdateProfileViewModel.Input(
            nickNameText: mainView.nickNameTextField.rx.text.orEmpty
            
        )
        
        let output = viewModel.transform(input: input)
        
        output.nickNameValid
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isEnabled = (value.1 != owner.nickname) && value.0
                owner.mainView.nickNameValidLabel.isHidden = value.0
            }
            .disposed(by: disposeBag)
        
        
        
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
