//
//  MyPageViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
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
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
   
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        
        var profile: MyProfileResponse?
        
        let input = MyPageViewModel.Input(
            requestProfile: requestProfile
        )
        
        let output = viewModel.transform(input: input)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.profile
            .bind(with: self) { owner, value in
                profile = value
                owner.mainView.setInfo(nick: value.nick, profile: value.profile)
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
        
        
    
    }
    
    
    
}
