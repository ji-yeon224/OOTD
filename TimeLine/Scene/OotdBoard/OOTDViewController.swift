//
//  OOTDViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class OOTDViewController: BaseViewController {
    
    private let mainView = OOTDView()
    private let viewModel = OOTDViewModel()
    private let disposeBag = DisposeBag()
    
    private let requestPost = BehaviorRelay(value: true)
    
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
        
        let input = OOTDViewModel.Input(
            requestPost: requestPost
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .bind(to:  mainView.collectionView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
       
        
    }
    
    
    
}

extension OOTDViewController {
    
    private func configNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.plus, style: .plain, target: self, action: #selector(writeButtonTap))
        
    }
    
    @objc private func writeButtonTap() {
        let vc = OOTDWriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
