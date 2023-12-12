//
//  MyPageViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit
import RxSwift

final class MyPageViewController: BaseViewController {
    
    private let mainView = MyPageView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileAPIManager.shared.request(api: .myProfile, type: MyProfileResponse.self)
            .subscribe(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func configure() {
        super.configure()
        configNavBar()
    }
    
    private func configNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MyPage"
    }
    
}
