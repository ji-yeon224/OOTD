//
//  BoardViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class BoardViewController: BaseViewController {
    
    private let mainView = BoardView()
    private let viewModel = BoardViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    
    let refreshList = PublishSubject<Bool>()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList.onNext(true)
    }
    private func bind() {
        
        let input = BoardViewModel.Input(
            refresh: refreshList,
            page: mainView.tableView.rx.prefetchRows
        )
        let output = viewModel.transform(input: input)
        
        
        
        mainView.writeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = BoardWriteViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
       
        output.items
            .bind(to: mainView.tableView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
        
        output.tokenRequest
            .bind(with: self) { owner, value in
                switch value {
                case .login:
                    owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                        UserDefaultsHelper.isLogin = false
                        // 로그인 뷰로 present
                        let vc = LoginViewController()
                        vc.transition = .presnt
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        owner.present(vc, animated: true)
                    }
                case .error:
                    owner.showOKAlert(title: "요청을 처리하지 못하였습니다. 다시 시도해주세요.", message: "") { }
                case .success:
                    break
                    
                }
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    
    
    
    
    
}
