//
//  UpdateProfileView.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import PhotosUI

final class UpdateProfileView: BaseView {
    
    private let imageBackView = UIView()
    let imageViewSize = CGSize(width: 100, height: 100)
    let profileImageView = ProfileImageView(frame: .zero)
    weak var delegate: PhPickerProtocol?
    
    let editImage = {
        let view = UIImageView()
        view.image = Constants.Image.pencil
        view.backgroundColor = .clear
        view.tintColor = Constants.Color.mainColor
        
        return view
    }()
    
    private let nicknameLabel = PlainLabel(size: 14, color: Constants.Color.basicText, weight: .semibold)
    
    let nickNameTextField = {
        let view = UITextField()
        view.placeholder = "닉네임을 입력해주세요!"
        view.font = .systemFont(ofSize: 14)
        view.tintColor = Constants.Color.mainColor
        view.layer.cornerRadius = 5
        view.layer.borderColor = Constants.Color.placeholder.cgColor
        view.layer.borderWidth = 1
        view.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0))
        view.leftViewMode = .always
        return view
    }()
    
    let nickNameValidLabel = PlainLabel(size: 14, color: Constants.Color.basicText)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        editImage.layer.cornerRadius = editImage.frame.width/2
        
    }
    
    override func configure() {
        
        [imageBackView, nicknameLabel, nickNameTextField, nickNameValidLabel].forEach {
            addSubview($0)
        }
        
        [profileImageView, editImage].forEach {
            imageBackView.addSubview($0)
        }
        
        nicknameLabel.text = "닉네임"
        
        nickNameValidLabel.isHidden = true
        nickNameValidLabel.text = "2글자 이상 8글자 이하로 작성해주세요!"
        profileImageView.isUserInteractionEnabled = true
    }
    
    override func setConstraints() {
        
        imageBackView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.size.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalTo(imageBackView)
            
        }
        editImage.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageBackView)
            make.size.equalTo(30)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
            make.height.equalTo(20)
            make.top.equalTo(imageBackView.snp.bottom).offset(30)
        }
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
            make.height.equalTo(40)
        }
        nickNameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(25)
        }
        
    }
    func configPHPicker(limit: Int = 1) -> PHPickerViewController {
        
        var photoConfiguration = PHPickerConfiguration()
        photoConfiguration.selectionLimit = limit
        photoConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        return picker
    }
}


// PHPicker
extension UpdateProfileView: PHPickerViewControllerDelegate {
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        delegate?.didFinishPicking(picker: picker, results: results)
    }
}
