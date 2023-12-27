//
//  AccountSettingViewController.swift
//  OOTD
//
//  Created by 김지연 on 12/21/23.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountSettingViewController: BaseViewController {
    
    private let mainView = AccountSettingView()
    private let viewModel = AccountSettingViewModel()
    private let disposeBag = DisposeBag()
    
    private let content = [
        MyPageContent(img: nil, title: "로그아웃", textColor: .systemBlue, type: .logout),
        MyPageContent(img: nil, title: "탈퇴", textColor: .systemRed, type: .withdraw)
    ]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        title = "계정"
    }
    
    override func configure() {
        view.backgroundColor = .secondarySystemBackground
        updateSnapShot()
    }
    
    func bind() {
        let logoutTap = PublishRelay<Bool>()
        let withdrawTap = PublishRelay<Bool>()
        
        let input = AccountSettingViewModel.Input(
            withdrawTap: withdrawTap
        )
        
        let output = viewModel.transform(input: input)
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
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
        
        output.withdraw
            .bind(with: self) { owner, value in
                if value {
                    owner.showOKAlert(title: "탈퇴가 완료되었습니다.", message: "") {
                        UserDefaultsHelper.initToken()
                        // 로그인 뷰로 present
                        owner.view?.window?.rootViewController = LoginViewController()
                        owner.view.window?.makeKeyAndVisible()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .map {
                return self.content[$0.row]
            }
            .bind(with: self) { owner , value in
                if value.type == .withdraw {
                    owner.showAlertWithCancel(title: "탈퇴 하시겠어요?", message: "") {
                        withdrawTap.accept(true)
                    } cancelHandler: {  }
                } else if value.type == .logout {
                    logoutTap.accept(true)
                }
               
            }
            .disposed(by: disposeBag)
        
        logoutTap
            .bind(with: self) { owner, value in
                UserDefaultsHelper.initToken()
                owner.view?.window?.rootViewController = LoginViewController()
                owner.view.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, MyPageContent>()
        snapshot.appendSections([""])
        snapshot.appendItems(content)
//        snapshot.appendItems(account, toSection: "계정")
        mainView.dataSource.apply(snapshot)
    }
    
}
