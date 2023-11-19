//
//  BoardViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit

final class BoardViewController: BaseViewController {
    
    private let mainView = BoardView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
