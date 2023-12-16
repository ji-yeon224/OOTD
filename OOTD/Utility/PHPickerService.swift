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
    
    func presentPicker(vc: UIViewController, prevIdentifiers:[String]? = nil) {
        self.viewController = vc
        let filter = PHPickerFilter.images
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 1
        if let prevIdentifiers{
            configuration.preselectedAssetIdentifiers = prevIdentifiers
        }
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.modalTransitionStyle = .crossDissolve
        
        viewController?.present(picker, animated: true)
    }
}

extension PHPickerService: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        guard let viewController else {return}
        if results.isEmpty {
            viewController.dismiss(animated: true)
        } else {
            viewController.dismiss(animated: false) {
                
                
                if let select = results.first {
                    let item = select.itemProvider
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        
                        DispatchQueue.main.async {
                            guard let img = image as? UIImage else {
                                return
                            }
                            
                            let vc = OOTDWriteViewController(selectImage: img)
//                            vc.selectImage = img
                            viewController.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
                
                
                
            }
        }
        
    }
}
