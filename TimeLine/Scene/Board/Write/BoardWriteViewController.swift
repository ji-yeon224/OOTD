//
//  BoardWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

final class BoardWriteViewController: BaseViewController {
    
    private let mainView = BoardWriteView()
    private let viewModel = BoardWriteViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let postButtonClicked = PublishRelay<Bool>()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "글쓰기"
        bind()
        testData()
    }
    
    func testData() {
        let image1 = UIImage(named: "img1")!
        let image2 = UIImage(named: "img2")!
        let image3 = UIImage(named: "img3")!
        let image4 = UIImage(named: "img4")!
        let image5 = UIImage(named: "img5")!
        
        viewModel.selectedImage.append(contentsOf: [image1, image2, image3, image4, image5])
        updateSnapShot()
    }
    
    override func configure() {
        super.configure()
        configNavBar()
        
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, UIImage>()
        snapShot.appendSections([0])
        snapShot.appendItems(viewModel.selectedImage)
        mainView.dataSource.apply(snapShot)
    }

    private func bind() {
        
        let input = BoardWriteViewModel.Input(
            postButton: postButtonClicked,
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentText: mainView.contentTextView.rx.text.orEmpty
        )
        
        let output = viewModel.trasform(input: input)
        
        output.postButtonEnabled
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        
        
        
        mainView.contentTextView.rx.text.orEmpty
            .bind(with: self) { owner, value in
                if value.count == 0 {
                    owner.mainView.placeHolderLabel.isHidden = false
                } else {
                    owner.mainView.placeHolderLabel.isHidden = true
                }
                owner.mainView.scrollView.updateContentView()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func configNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func completeButtonTapped() {
        postButtonClicked.accept(true)
    }
    
    
    
}


