//
//  LikePostViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class LikePostViewController: BaseViewController {
    
    private let mainView = BoardView()
    private let viewModel = BoardViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let requestPost = BehaviorRelay(value: true)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        mainView.writeButton.isHidden = true
        title = "좋아요"
    }
    
    override func configure() {
        
        
    }
    
    private func bind() {
        
        
        
    }
    
}
