//
//  BoardWriteViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import RxDataSources

final class BoardWriteViewController: BaseViewController {
    
    private let mainView = BoardWriteView()
    private let viewModel = BoardWriteViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let postButtonClicked = PublishRelay<Bool>()
    private var imageList: [SelectedImage] = []
    private let maxImageCount = 3
    
    private var pickedImageDict = [String: PHPickerResult]()
    private var imgIdentifier = [String]()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "글쓰기"
        bind()
        
    }
    

    
    override func configure() {
        super.configure()
        configNavBar()
        configToolBar()
        mainView.delegate = self
    }


    private func bind() {
        
        let rxDataSource = RxCollectionViewSectionedReloadDataSource<SelectImageModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = item.image
            
            
            return cell
        }
        
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
        
        output.items
            .bind(to: mainView.imagePickCollectionView.rx.items(dataSource: rxDataSource))
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
    
    private func configToolBar() {
        let photobutton = UIBarButtonItem(image: Constants.Image.photo, style: .plain, target: self, action: #selector(selectPhotoButton))
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(image: Constants.Image.keyboardDown, style: .plain, target: self, action: #selector(doneButtonTapped))
        
        photobutton.tintColor = Constants.Color.basicText
        doneButton.tintColor = Constants.Color.basicText
        
        mainView.toolbar.setItems([photobutton, flexibleSpaceButton, doneButton], animated: true)
    }
    
    @objc private func selectPhotoButton() {
       
        view.endEditing(true)
        
        present(mainView.configPHPicker(), animated: true)
    }
    
    @objc private func doneButtonTapped() {
        
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
        
        results.forEach {
            dispatchGroup.enter()
            let item = $0.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self) {
                // loadObject -> 비동기로 동작
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let img = image as? UIImage else { return }
                        self.imageList.append(SelectedImage(image: img))
                        dispatchGroup.leave()
                        
                    }
                    
                }

            } else {
                print("이미지 로드 실패")
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            
            self.viewModel.imageList.accept(imageList)
        }
        
    }
    
    
}


