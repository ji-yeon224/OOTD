//
//  OOTDWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit

final class OOTDWriteViewController: BaseViewController {
    
    private let mainView = OOTDWriteView()
    private var selectImage: UIImage?
    
    override func loadView() {
        self.view = mainView
    }
    
    init(selectImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.selectImage = selectImage
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "게시물 작성"
        guard let image = selectImage else {
            self.showOKAlert(title: "문제가 발생하였습니다.", message: "이미지를 불러올 수 없습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        mainView.imageView.image = selectImage
    }
    
    override func configure() {
        super.configure()
        
    }
    
    
}
