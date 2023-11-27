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
import PhotosUI

final class BoardWriteViewController: BaseViewController {
    
    private let mainView = BoardWriteView()
    private let viewModel = BoardWriteViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let postButtonClicked = PublishRelay<Bool>()
    private let selectedImage = PublishRelay<[UIImage]>()
    
    private var pickedImageDict: [String: PHPickerResult] = [:]
    private var identififer: [String] = []
    //var selectedAssetIdentifiers = [String]()
    
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "글쓰기"
        bind()
//        testData()
    }
    
//    func testData() {
//        let image1 = UIImage(named: "img1")!
//        let image2 = UIImage(named: "img2")!
//        let image3 = UIImage(named: "img3")!
//        let image4 = UIImage(named: "img4")!
//        let image5 = UIImage(named: "img5")!
//        
//        //viewModel.selectedImage.append(contentsOf: [image1, image2, image3, image4, image5])
//        
//    }
    
    override func configure() {
        super.configure()
        configNavBar()
        configToolBar()
        mainView.delegate = self
    }
    
    private func updateSnapShot(_ imgList: [UIImage]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, UIImage>()
        snapShot.appendSections([0])
        snapShot.appendItems(imgList)
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
        
        
        selectedImage
            .debug()
            .bind(with: self) { owner, images in
                owner.updateSnapShot(images)
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
    
    private func configToolBar() {
        let photobutton = UIBarButtonItem(image: Constants.Image.photo, style: .plain, target: self, action: #selector(selectPhotoButton))
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(image: Constants.Image.keyboardDown, style: .plain, target: self, action: #selector(doneButtonTapped))
        
        photobutton.tintColor = Constants.Color.basicText
        doneButton.tintColor = Constants.Color.basicText
        
        mainView.toolbar.setItems([photobutton, flexibleSpaceButton, doneButton], animated: true)
    }
    @objc private func selectPhotoButton() {
        print("button")
        view.endEditing(true)
        
        present(mainView.picker, animated: true)
    }
    
    @objc private func doneButtonTapped() {
        print("done")
        view.endEditing(true)
    }
    
    
}

extension BoardWriteViewController: PhPickerProtocol {
    func didFinishPicking(picker: PHPickerViewController, results: [PHPickerResult]) {

        picker.dismiss(animated: true)
        
        if results.isEmpty {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var imageList: [UIImage] = []
        results.forEach {
            dispatchGroup.enter()
            let item = $0.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self) {
                // loadObject -> 비동기로 동작
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let img = image as? UIImage else { return }
                        imageList.append(img)
                        dispatchGroup.leave()
                        
                    }
                    
                }

            } else {
                print("이미지 로드 실패")
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            self.selectedImage.accept(imageList)
        }
        
    }
    
    
}


