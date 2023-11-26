//
//  BoardWriteView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import RxDataSources
import RxSwift
import IQKeyboardManagerSwift

final class BoardWriteView: BaseView {
    
    private let scrollView = {
        let view = UIScrollView()
        view.updateContentView()
        return view
    }()
    
    private let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))
    
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
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UIImage>!
    
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
        configureDataSource()
        configToolBar()
    }
    
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
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
    
    private func configToolBar() {
        let photobutton = UIBarButtonItem(image: Constants.Image.photo, style: .plain, target: self, action: #selector(selectPhotoButton))
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(image: Constants.Image.keyboardDown, style: .plain, target: self, action: #selector(doneButtonTapped))
        
        photobutton.tintColor = Constants.Color.basicText
        doneButton.tintColor = Constants.Color.basicText
        
        toolbar.setItems([photobutton, flexibleSpaceButton, doneButton], animated: true)
    }
    
    @objc private func selectPhotoButton() {
        print("button")
    }
    
    @objc private func doneButtonTapped() {
        print("done")
        endEditing(true)
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
    
    private func configureDataSource() {
            
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, UIImage> { cell, indexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: imagePickCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
            
    }
    
}
