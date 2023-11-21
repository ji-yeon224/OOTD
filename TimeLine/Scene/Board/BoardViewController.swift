//
//  BoardViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardViewController: BaseViewController {
    
    private let mainView = BoardView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        mainView.writeButton.rx.tap
            .debug()
            .bind(with: self) { owner, _ in
                let vc = BoardWriteViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
