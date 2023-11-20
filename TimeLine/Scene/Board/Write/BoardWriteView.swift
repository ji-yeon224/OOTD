//
//  BoardWriteView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit

final class BoardWriteView: BaseView {
    
    let scrollView = {
        let view = UIScrollView()
        view.updateContentView()
        return view
    }()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
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
    
    override func configure() {
        super.configure()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(contentTextView)
        contentTextView.addSubview(placeHolderLabel)
        
        titleTextField.becomeFirstResponder()
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
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentTextView)
            make.leading.equalTo(contentTextView).offset(21)
            make.width.equalTo(contentTextView)
            make.height.equalTo(30)
        }
        
    }
    
}
