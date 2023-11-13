//
//  BaseViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() { view.backgroundColor = Constants.Color.background }
    
}
