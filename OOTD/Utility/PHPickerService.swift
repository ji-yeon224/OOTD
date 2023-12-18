//
//  PHPickerService.swift
//  TimeLine
//
//  Created by 김지연 on 12/15/23.
//

import UIKit
import PhotosUI
import RxSwift

final class PHPickerService {
    
    static let shared = PHPickerService()
    private init() { }
    private weak var viewController: UIViewController?
    private var fullScreenType: Bool = false
    let selectedImage = PublishSubject<UIImage>()
    let disposeBag = DisposeBag()
    
    func presentPicker(vc: UIViewController, selectLimit: Int = 1, fullScreenType: Bool) {
        self.viewController = vc
        self.fullScreenType = fullScreenType
        let filter = PHPickerFilter.images
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = selectLimit
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        if fullScreenType {
            picker.modalPresentationStyle = .fullScreen
            picker.modalTransitionStyle = .crossDissolve
        }
        
        
        viewController?.present(picker, animated: true)
    }
}

extension PHPickerService: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        guard let viewController else {return}
        if results.isEmpty {
            viewController.dismiss(animated: true)
        } else {
            
            
            viewController.dismiss(animated: !fullScreenType) {
                
                
                if let select = results.first {
                    let item = select.itemProvider
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        
                        DispatchQueue.main.async {
                            guard let img = image as? UIImage else {
                                return
                            }
                            self.selectedImage.onNext(img)
//                            let vc = OOTDWriteViewController(selectImage: img)
//                            vc.selectImage = img
//                            viewController.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
            }
        }
        
    }
}
