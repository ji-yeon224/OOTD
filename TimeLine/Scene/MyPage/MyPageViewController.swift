//
//  MyPageViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/12/23.
//

import UIKit

final class MyPageViewController: BaseViewController {
    
    private let mainView = MyPageView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
