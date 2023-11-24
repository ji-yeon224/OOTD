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
    
    
    
    let refreshList = BehaviorSubject(value: true)
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    private func bind() {
        
        let input = BoardViewModel.Input(refresh: refreshList)
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
        
        
        
        
    }
    
    
    
    
    
    
}
