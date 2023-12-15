//
//  OOTDWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class OOTDWriteViewController: BaseViewController {
    
    private let mainView = OOTDWriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "게시물 작성"
        mainView.imageView.image = UIImage(named: "img6")
    }
    
    override func configure() {
        super.configure()
        
    }
    
    
}
