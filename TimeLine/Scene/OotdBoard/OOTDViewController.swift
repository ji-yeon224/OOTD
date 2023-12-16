//
//  OOTDViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDViewController: BaseViewController {
    
    private let mainView = OOTDView()
    private let viewModel = OOTDViewModel()
    private let disposeBag = DisposeBag()
    
    private let requestPost = PublishRelay<Bool>()
    
    override func loadView() {
        self.view = mainView
        mainView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        requestPost.accept(true)
        
    }
    
    
    override func configure() {
        super.configure()
        configNavBar()
    }
    
    private func bind() {
        
        let input = OOTDViewModel.Input(
            callFirstPage: requestPost,
            page: mainView.collectionView.rx.prefetchItems
        )
        
        let output = viewModel.transform(input: input)
        
        
        
        
        
        output.items
            .bind(to:  mainView.collectionView.rx.items(dataSource: mainView.dataSource))
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
                    vc.completionHandler = {
                        owner.requestPost.accept(true)
                    }
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.refreshPhoto)
            .bind(with: self) { owner, noti in
                owner.requestPost.accept(true)
            }
            .disposed(by: disposeBag)
        
        
        
        
    }
    
    
    
}

extension OOTDViewController {
    
    private func configNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.plus, style: .plain, target: self, action: #selector(writeButtonTap))
        
    }
    
    @objc private func writeButtonTap() {
       
        PHPickerService.shared.presentPicker(vc: self)
        
    }
    
    
}

extension OOTDViewController: OOTDCellProtocol {
    func editPost(item: Post) {
        print("edit", item.content)
    }
    
    func deletePost(id: String) {
        print("delete", id)
    }
    
}
