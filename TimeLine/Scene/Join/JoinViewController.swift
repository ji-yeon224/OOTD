//
//  JoinViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import UIKit

final class JoinViewController: BaseViewController {
    
    private let mainView = JoinView()
    private let viewModel = JoinViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        
    }
}
