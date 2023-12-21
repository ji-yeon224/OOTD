//
//  MyPageViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

final class MyPageViewController: BaseViewController {
    
    private let mainView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    
    private let requestProfile = BehaviorRelay(value: true)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        print(UserDefaultsHelper.token)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        configNavBar()
        
    }
    
    private func bind() {
        
        var profile: MyProfileResponse?
        let logoutTap = PublishRelay<Bool>()
        let withdrawTap = PublishRelay<Bool>()
        
        let input = MyPageViewModel.Input(
            requestProfile: requestProfile,
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
                    vc.completionHandler = {
                        owner.requestProfile.accept(true)
                    }
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.profile
            .bind(with: self) { owner, value in
                profile = value
                owner.mainView.setInfo(nick: value.nick, profile: value.profile)
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
        
        
        mainView.profileView.editButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let info = profile else {
                    owner.showOKAlert(title: "", message: "문제가 발생하였습니다.") { }
                    return
                }
                let vc = UpdateProfileViewController(nick: info.nick, image: info.profile )
                vc.updateHandler = { value in
                    profile = value
                    owner.mainView.setInfo(nick: value.nick, profile: value.profile)
                    NotificationCenter.default.post(name: .refresh, object: nil)
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        logoutTap
            .bind(with: self) { owner, value in
                UserDefaultsHelper.initToken()
                owner.view?.window?.rootViewController = LoginViewController()
                owner.view.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)

        
        
        mainView.collectionView.rx.itemSelected
            .bind(with: self) { owner, value in
                let type = list[value.row].type
                switch type {
                case .likeboard:
                    let vc = BoardViewController()
                    vc.boardType = .my
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .mypost: print("post")
                case .withdraw:
                    owner.showAlertWithCancel(title: "탈퇴 하시겠어요?", message: "") {
                        withdrawTap.accept(true)
                    } cancelHandler: {  }

                    
                case .logout:
                    logoutTap.accept(true)
                }
                
            }
            .disposed(by: disposeBag)
        
        mainView.menuButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = AccountSettingViewController()
                
                let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
                let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
                    // safe area bottom을 구하기 위한 선언.
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0

                    return 200 - safeAreaBottom
                }
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [customDetent]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                }
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(mainView.collectionView.rx.itemSelected, mainView.collectionView.rx.modelSelected(MyPageContent.self))
//            .bind(with: self) { owner, value in
//                print(value.1)
//            }
//            .map {
//                return $1.type
//            }
//            .bind(with: self) { owner, type in
//                switch type {
//                case .likeboard: print("likeboard")
//                case .mypost: print("post")
//                case .withdraw: print("witdraw")
//                    //withdrawTap.accept(true)
//                case .logout: print("logout")
//                    //logoutTap.accept(true)
//                }
//            }
//            .disposed(by: disposeBag)
        
        
    
    }
    
    
    
    private func configNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.menuButton, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
}
