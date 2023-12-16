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
    
    private let postButtonClicked = PublishRelay<BoardMode>()
    private let updateButtonClicked = PublishRelay<Bool>()

    private var ableSelectImage = 3
    
    var postHandler: ((Post) -> Void)?
    
    var editData: Post?
    var boardMode: BoardMode = .add
    
    private lazy var photoButton = UIBarButtonItem(image: Constants.Image.photo, style: .plain, target: self, action: nil)
    
    private lazy var doneButton = UIBarButtonItem(image: Constants.Image.keyboardDown, style: .plain, target: self, action: nil)
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "글쓰기"
        bind()
        
        switch boardMode {
        case .edit(let data):
            editData = data
            viewModel.postID = data.id
            configEditData(data)
        case .add:
            break
        }
        
    }
    
    private func configEditData(_ data: Post) {
        mainView.titleTextField.text = data.title
        mainView.contentTextView.text = data.content
        var imgList: [SelectedImage] = []
        data.image.forEach { url in
            if let img = ImageManager.shared.downloadImage(with: url) {
                imgList.append(SelectedImage(image: img))
            }
            
        }
        
        viewModel.setImageItems(imgList)
    }

    
    override func configure() {
        super.configure()
        configNavBar()
        configToolBar()
        mainView.delegate = self
    }


    private func bind() {
        
        let imageDelete = PublishRelay<Int>()
        
        let rxDataSource = RxCollectionViewSectionedReloadDataSource<SelectImageModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = item.image
            cell.cancelButton.rx.tap
                .bind(with: self) { owner, _ in
                    imageDelete.accept(indexPath.item)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        
        let input = BoardWriteViewModel.Input(
            postButton: postButtonClicked,
            updateButton: updateButtonClicked,
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentText: mainView.contentTextView.rx.text.orEmpty,
            imageDelete: imageDelete
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
        
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
//                print("[BOARD WRITE] ", value)
            }
            .disposed(by: disposeBag)
        
        output.enableAddImage
            .bind(with: self) { owner, value in
//                owner.photoButton.isEnabled = value
                owner.photoButton.tintColor = value ? Constants.Color.basicText : Constants.Color.disableTint
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
        
        output.successPost
            .bind(with: self) { owner, value in
                if value.0, let data = value.2 {
                    var msg: String
                    switch owner.boardMode {
                    case .edit:
                        msg = "게시글 수정이 완료되었습니다!"
                        NotificationCenter.default.post(name: .reloadHeader, object: nil)
                    case .add:
                        msg = "게시글 작성이 완료되었습니다!"
                    }
                    owner.showOKAlert(title: "", message: msg) {
                        
                        NotificationCenter.default.post(name: .refresh, object: nil)
                        
                        owner.navigationController?.popViewController(animated: false)
                        owner.postHandler?(data)
                    }
                    
                }
                else {
                    owner.showOKAlert(title: "문제가 발생하였습니다", message: value.1, handler: nil)
                }
            }
            .disposed(by: disposeBag)
        
        photoButton.rx.tap
            .bind(with: self) { owner, _ in
                if output.enableAddImage.value {
                    owner.view.endEditing(true)
                    owner.present(owner.mainView.configPHPicker(limit: owner.viewModel.selectCount), animated: true)
                } else {
                    owner.showToastMessage(message: "이미지는 최대 3장까지 선택할 수 있습니다.", position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    
    private func configNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func completeButtonTapped() {
        postButtonClicked.accept(boardMode)
        
        
    }
    
    private func configToolBar() {
        
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        photoButton.tintColor = Constants.Color.basicText
        doneButton.tintColor = Constants.Color.basicText
        
        mainView.toolbar.setItems([photoButton, flexibleSpaceButton, doneButton], animated: true)
    }
    
    
}

extension BoardWriteViewController: PhPickerProtocol {
  

    func didFinishPicking(picker: PHPickerViewController, results: [PHPickerResult]) {

        picker.dismiss(animated: true)
        
        if results.isEmpty {
            return
        }
        var imageList: [SelectedImage] = []
        let dispatchGroup = DispatchGroup()
        
        results.forEach {
            dispatchGroup.enter()
            let item = $0.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self) {
                // loadObject -> 비동기로 동작
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let img = image as? UIImage else { return }
                        imageList.append(SelectedImage(image: img))
                        dispatchGroup.leave()
                        
                    }
                    
                }

            } else {
                print("이미지 로드 실패")
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.viewModel.setImageItems(imageList)
        }
        
    }
    
    
}


