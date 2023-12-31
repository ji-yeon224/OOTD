//
//  UpdateProfileViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa

final class UpdateProfileViewController: BaseViewController {
    
    private let mainView = UpdateProfileView()
    private let viewModel = UpdateProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private let nicknameTextField = PublishRelay<String>()
    private let updateProfile = PublishRelay<ProfileUpdateRequest>()
    private let updatePhoto = BehaviorRelay(value: false)
    
    
    private var nickname: String?
    private var profile: String?
    
    var updateHandler: ((MyProfileResponse) -> Void)?
    
    init(nick: String, image: String?) {
        super.init(nibName: nil, bundle: nil)
        mainView.setProfile(nick: nick, image: image)
        viewModel.originNick = nick
        nickname = nick
        profile = image
    }
    
    @available(*, unavailable)
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
        configGesture()
    }
    
    private func bind() {
        
        var nickValid = true
        
        let input = UpdateProfileViewModel.Input(
            nickNameText: mainView.nickNameTextField.rx.text.orEmpty,
            updateProfile: updateProfile,
            updatePhoto: updatePhoto
        )
        
        let output = viewModel.transform(input: input)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.nickNameValid
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isEnabled = value
                nickValid = value
                owner.mainView.nickNameValidLabel.isHidden = value
            }
            .disposed(by: disposeBag)
        
        updatePhoto
            .bind(with: self) { owner, value in
                if nickValid && value {
                    owner.navigationItem.rightBarButtonItem?.isEnabled = value
                }
            }
            .disposed(by: disposeBag)
        
        
        output.updateSuccess
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "", message: "프로필 변경이 완료되었습니다.") {
                    owner.updateHandler?(value)
                    owner.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .refreshPhoto, object: nil)
                }
                
                
            }
            .disposed(by: disposeBag)
        
        output.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.isLogin = false
                    // 로그인 뷰로 present
                    let vc = LoginViewController()
                    vc.transition = .presnt
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}


extension UpdateProfileViewController {
    
    private func configGesture() {
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        mainView.profileImageView.addGestureRecognizer(imageTap)
        
    }
    
    @objc private func didTapView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "사진 삭제", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.mainView.profileImageView.image = Constants.Image.placeholderProfile
            if let img = Constants.Image.placeholderProfile {
                self.viewModel.selectedImg = SelectedImage(image: img)
            } else {
                self.viewModel.selectedImg = nil
            }
           
            self.updatePhoto.accept(true)
        }
        let selectPhoto = UIAlertAction(title: "사진 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            PHPickerManager.shared.presentPicker(vc: self, fullScreenType: false)
            PHPickerManager.shared.selectedImage
                .subscribe(with: self) { owner, image in
                    guard let img = image.first?.resizeV3(to: self.mainView.imageViewSize) else {
                        owner.showOKAlert(title: "", message: "이미지를 불러올 수 없습니다.") { }
                        return
                    }
                    owner.viewModel.selectedImg = SelectedImage(image: img)
                    owner.mainView.profileImageView.image = img
                    self.updatePhoto.accept(true)
                }
                .disposed(by: PHPickerManager.shared.disposeBag)
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        [selectPhoto, delete, cancel].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    
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
        if let nickname = mainView.nickNameTextField.text {
            let update = ProfileUpdateRequest(nick: nickname.trimmingCharacters(in: .whitespaces), profile: nil)
            updateProfile.accept(update)
        }
    }
    
    @objc private func backButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

