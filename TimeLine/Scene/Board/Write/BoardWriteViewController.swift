//
//  BoardWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit


final class BoardWriteViewController: BaseViewController {
    
    private let mainView = BoardWriteView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title"
    }
    
    override func configure() {
        super.configure()
        
    }
    
}
