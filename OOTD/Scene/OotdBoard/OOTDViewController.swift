//
//  OOTDViewController.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import RxSwift
import RxCocoa


final class OOTDViewController: BaseViewController {
    
    private let mainView = OOTDView()
    private let viewModel = OOTDViewModel()
    private let disposeBag = DisposeBag()
    
    private let requestPost = PublishRelay<Bool>()
    private let requestDelete = PublishRelay<(String, Int)>()
    private let likeButton = PublishRelay<String>()
    
    var mode: OotdBoardMode = .main
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        requestPost.accept(true)
        
    }
    
    override func configure() {
        super.configure()
        configNavBar()
        mainView.delegate = self
        
        mainView.collectionView.refreshControl = UIRefreshControl()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
       
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.requestPost.accept(true)
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
        }
    }
    
    private func bind() {
        
        let input = OOTDViewModel.Input(
            callFirstPage: requestPost,
            page: mainView.collectionView.rx.prefetchItems,
            deleteRequest: requestDelete,
            likeButton: likeButton
        )
        
        let output = viewModel.transform(input: input)
        
        
        output.items
            .bind(to:  mainView.collectionView.rx.items(dataSource: mainView.dataSource))
            .disposed(by: disposeBag)
        
       
        output.errorMsg
            .bind(with: self) { owner, value in
                owner.showToastMessage(message: value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.loginRequest
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "문제가 발생하였습니다.", message: "로그인 후 다시 시도해주세요.") {
                    UserDefaultsHelper.initToken()
                    // 로그인 뷰로 present
                    let vc = LoginViewController()
                    vc.transition = .presnt
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.completionHandler = {
                        owner.requestPost.accept(true)
                    }
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.successDelete
            .bind(with: self) { owner, _ in
                owner.showOKAlert(title: "삭제", message: "삭제가 완료되었습니다.") {  }
            }
            .disposed(by: disposeBag)
        
        output.likeSuccess
            .bind(with: self) { owner, value in
                if value {
                    owner.mainView.likeData.accept(true)
                } else { // 좋아요 반영 실패 시 -> 통신 오류
                    owner.mainView.likeData.accept(false)
                    owner.showToastMessage(message: "좋아요 반영에 실패하였습니다.", position: .top)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.refreshPhoto)
            .bind(with: self) { owner, noti in
                owner.requestPost.accept(true)
            }
            .disposed(by: disposeBag)
        
        
        
        
    }
    
    
    
}

extension OOTDViewController {
    
    private func configNavBar() {
        
        navigationController?.navigationBar.backgroundColor = Constants.Color.background
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.plus, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .clear
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.plus, style: .plain, target: self, action: #selector(writeButtonTap))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            imageView.contentMode = .scaleAspectFit
        let image = Constants.Image.mainLogo
            imageView.image = image
            navigationItem.titleView = imageView
        
    }
    
    @objc private func writeButtonTap() {
       
        PHPickerManager.shared.presentPicker(vc: self, fullScreenType: true)
        PHPickerManager.shared.selectedImage
            .bind(with: self) { owner, image in
                let vc = OOTDWriteViewController(selectImage: image.first)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: PHPickerManager.shared.disposeBag)
        
    }
    
    
}

extension OOTDViewController: OOTDCellProtocol {
    func likeButtonTap(id: String) {
        likeButton.accept(id)
    }
    
    func showComment(comments: [Comment], id: String) {
        let vc = OOTDCommentViewController()
        vc.comments = comments
        vc.id = id
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
        
        
    }
    
    func editPost(item: Post) {
        print("edit", item.content)
        let vc = OOTDWriteViewController(imgString: item.image[0])
        vc.boardMode = .edit(data: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deletePost(id: String, idx: Int) {
        print("delete", id)
        showAlertWithCancel(title: "삭제", message: "해당 게시글을 삭제하시겠어요?") {
            self.requestDelete.accept((id, idx))
        } cancelHandler: { }

        
    }
    
}
