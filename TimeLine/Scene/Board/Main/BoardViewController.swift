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
    
    private let refreshList = PublishRelay<Bool>()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        refreshList.accept(true)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        refreshList.accept(true)
//        viewModel.data.removeAll()
    }
    
    override func configure() {
        mainView.tableView.refreshControl = UIRefreshControl()
        mainView.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    private func bind() {
        
        let input = BoardViewModel.Input(
            page: mainView.tableView.rx.prefetchRows,
            callFirst: refreshList
        )
        let output = viewModel.transform(input: input)
        
        mainView.tableView.rx.modelSelected(Post.self)
        .bind(with: self) { owner, value in
            let vc = BoardReadViewController()
            vc.postData = value
            vc.modalPresentationStyle = .overFullScreen
            owner.navigationController?.pushViewController(vc, animated: true)
            
        }
        .disposed(by: disposeBag)
        
        
        
        mainView.writeButton.rx.tap
            .bind(with: self) { owner, _ in
                
                let vc = BoardWriteViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.postHandler = {
                    let readvc = BoardReadViewController()
                    readvc.postData = $0
                    owner.navigationController?.pushViewController(readvc, animated: false)
                }
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
                print("BOARD ERROR - ", value)
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
                        owner.refreshList.accept(true)
                        owner.viewModel.data.removeAll()
                    }
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
       
        output.items
            .bind(to: mainView.tableView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx.notification(.refresh)
            .bind(with: self) { owner, noti in
                owner.refreshList.accept(true)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    @objc private func refreshData() {
//        debugPrint("pull refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.refreshList.accept(true)
            self.mainView.tableView.refreshControl?.endRefreshing()
        }
        
    }
    
    
    
}
