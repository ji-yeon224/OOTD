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
        
        let image1 = UIImage(named: "img1")
        let image2 = UIImage(named: "img2")
        
        PostAPIManager.shared.request(api: .write(data: PostWrite(title: "test3", content: "tttt", product_id: "OOTDBoard")))
    }
    
    override func configure() {
        super.configure()
        
    }
    
}
