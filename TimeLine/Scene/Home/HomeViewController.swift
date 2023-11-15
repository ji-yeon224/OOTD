//
//  HomeViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    private let mainView = HomeView()
    private let disposeBag = DisposeBag()
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                UserDefaultsHelper.shared.isLogin = false
                owner.view?.window?.rootViewController = HomeViewController()
                owner.view.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
}
