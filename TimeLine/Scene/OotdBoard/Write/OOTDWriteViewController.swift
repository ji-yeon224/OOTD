//
//  OOTDWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDWriteViewController: BaseViewController {
    
    private let mainView = OOTDWriteView()
    private let viewModel = OOTDWriteViewModel()
    
    private var selectImage: UIImage?
    private var imageData: Data?
    
    private let disposeBag = DisposeBag()
    
    private let uploadButton = PublishRelay<Bool>()
    
    override func loadView() {
        self.view = mainView
    }
    
    init(selectImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.selectImage = selectImage
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    
    override func configure() {
        super.configure()
        
        configNavBar()
        
        title = "게시물 작성"
        guard let image = selectImage else {
            self.showOKAlert(title: "문제가 발생하였습니다.", message: "이미지를 불러올 수 없습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        mainView.imageView.image = image
//        imageData = image.resize(width: UIScreen.main.bounds.size.width).jpegData(compressionQuality: 0.5)
        print(imageData?.convertToMb)
    }
    
    
    private func bind() {
        
        let postRequest = PublishRelay<PostWrite>()
        
        let input = OOTDWriteViewModel.Input(postRequest: postRequest)
        let output = viewModel.transform(input: input)
        
        
        
        output.successPost
            .bind(with: self) { owner, value in
                let success = value.0
                if success {
                    owner.showOKAlert(title: "완료", message: "게시물 업로드를 완료했습니다.") {
                        owner.navigationController?.popViewController(animated: true)
                    }
                } else {
                    owner.showOKAlert(title: "실패", message: value.1) { }
                }
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.initToken()
                    // 로그인 뷰로 present
                    let vc = LoginViewController()
                    vc.transition = .presnt
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        
        mainView.contentTextView.rx.text.orEmpty
            .map {
                return $0.count == 0
            }
            .bind(with: self) { owner, value in
                owner.mainView.placeHolderLabel.isHidden = !value
                owner.navigationItem.rightBarButtonItem?.isEnabled = !value
            }
            .disposed(by: disposeBag)
        
        uploadButton
            .withLatestFrom(mainView.contentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, content in
                let data = PostWrite(title: "", content: content.trimmingCharacters(in: .whitespaces), file: [owner.selectImage?.compressionImage()], product_id: ProductId.OOTDPhoto.rawValue)
                postRequest.accept(data)
            }
            .disposed(by: disposeBag)
    }
    
}

extension OOTDWriteViewController {
    
    private func configNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(uploadButtonTap))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.back, style: .plain, target: self, action: #selector(backButtonTap))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
    }
    
    @objc private func uploadButtonTap() {
        
        uploadButton.accept(true)
    }
    
    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    
}
