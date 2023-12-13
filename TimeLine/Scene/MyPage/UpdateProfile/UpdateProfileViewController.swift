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
    private let update = PublishRelay<(String, SelectedImage)>()
    
    private var nickname: String?
    private var profile: String?
    
    var updateHandler: ((MyProfileResponse) -> Void)?
    
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
        configGesture()
        mainView.delegate = self
        
    }
    
    private func bind() {
        
        
        let input = UpdateProfileViewModel.Input(
            nickNameText: mainView.nickNameTextField.rx.text.orEmpty,
            updateProfile: updateProfile
        )
        
        let output = viewModel.transform(input: input)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.nickNameValid
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isEnabled = (value.1 != owner.nickname) && value.0
                owner.mainView.nickNameValidLabel.isHidden = value.0
            }
            .disposed(by: disposeBag)
        
        output.updateSuccess
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "", message: "프로필 변경이 완료되었습니다.") {
                    owner.updateHandler?(value)
                    owner.navigationController?.popViewController(animated: true)
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
            self.mainView.profileImageView.image = Constants.Image.person
        }
        let selectPhoto = UIAlertAction(title: "사진 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.present(self.mainView.configPHPicker(limit: 1), animated: true)
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        [delete, selectPhoto, cancel].forEach {
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

extension UpdateProfileViewController: PhPickerProtocol {
    
    func didFinishPicking(picker: PHPickerViewController, results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if results.isEmpty {
                return
            }
            
            if let select = results.first {
                let item = select.itemProvider
                if item.canLoadObject(ofClass: UIImage.self) {
                    
                    item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self, let img = image as? UIImage else { return }
                        DispatchQueue.main.async {
                            if let resizeImg = img.resizeV3(to: self.mainView.imageViewSize){
                                self.mainView.profileImageView.image = resizeImg
                                
                                self.viewModel.selectedImg = SelectedImage(image: resizeImg)
                            }
                            
                        }
                    }
                    
                }
            }
            
            
            
        
        
        
        
    }
    
    
    
}
