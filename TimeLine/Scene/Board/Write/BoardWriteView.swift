//
//  BoardWriteView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxDataSources
import PhotosUI

final class BoardWriteView: BaseView {
    
    let scrollView = {
        let view = UIScrollView()
        view.updateContentView()
        return view
    }()
    
    let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        return view
    }()
    
    let titleTextField = {
        let view = CustomTextField(placeholder: "제목을 입력하세요.")
        view.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 0.0))
        view.leftViewMode = .always
        return view
    }()
    lazy var contentTextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.font = .systemFont(ofSize: 15)
        view.textColor = Constants.Color.basicText
        view.backgroundColor = Constants.Color.background
        return view
    }()
    
    let placeHolderLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.placeholder
        view.text = "내용을 입력하세요."
        view.textAlignment = .left
        return view
    }()
    
    lazy var imagePickCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return view
    }()
    
    
    
    var delegate: PhPickerProtocol?
    
    
    override func configure() {
        super.configure()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(contentTextView)
        stackView.addArrangedSubview(imagePickCollectionView)
        contentTextView.addSubview(placeHolderLabel)
        
        addSubview(toolbar)
        
    
        titleTextField.becomeFirstResponder()
    }
    
    
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.edges.equalTo(scrollView)
        }
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(40)
        }
        contentTextView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
        }
        
        imagePickCollectionView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(130)
        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView).offset(10)
            make.leading.equalTo(contentTextView).offset(21)
            make.width.equalTo(contentTextView)
            make.height.equalTo(30)
        }
        
        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
    }
    
    func configData(data: Post) {
        titleTextField.text = data.title
        contentTextView.text = data.content
        
    }
    
    func configPHPicker(limit: Int = 3) -> PHPickerViewController {
        
        var photoConfiguration = PHPickerConfiguration()
        photoConfiguration.selectionLimit = limit
        photoConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        return picker
    }
    

    
    func configureCollectionLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(10) // 아이템 옆 간격
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        //section.interGroupSpacing = 10 // 줄 간격
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
    
    
    
}

extension BoardWriteView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        delegate?.didFinishPicking(picker: picker, results: results)

    }
    
}
