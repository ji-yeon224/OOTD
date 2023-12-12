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
    
    override func configure() {
        super.configure()
        configNavBar()
    }
    
    private func bind() {
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
                owner.mainView.profileView.nicknameLabel.text = value.nick
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    private func configNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MyPage"
    }
    
}
