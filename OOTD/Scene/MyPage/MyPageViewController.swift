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
    private let vc = MyPageTabViewController(id: UserDefaultsHelper.userID)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mypage")
        bind()
        mainView.userId = UserDefaultsHelper.userID
        print(UserDefaultsHelper.token)
        
        configChildView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        vc.willMove(toParent: nil)
        vc.removeFromParent()
        view.removeFromSuperview()
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        
        configNavBar()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        configChildView()
//    }
    
    private func configChildView() {
        mainView.layoutSubviews()
        addChild(vc)
        
        vc.view.frame = mainView.contentView.frame
        mainView.contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
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
                owner.mainView.userId = value._id
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
        
        NotificationCenter.default.rx.notification(.transitionDetail)
            .bind(with: self) { owner, _ in
                print("noti")
                let nav = UINavigationController(rootViewController: DetailPhotoViewController())
                owner.present(nav, animated: true)
//                owner.navigationController?.pushViewController(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    private func configNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.menuButton, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
}
