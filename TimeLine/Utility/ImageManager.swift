//
//  ImageManager.swift
//  TimeLine
//
//  Created by 김지연 on 12/4/23.
//

import UIKit
import Kingfisher

final class ImageManager {
    
    static let shared = ImageManager()
    private init() { }
    
    
    
    func downloadImage(with urlString : String) -> UIImage? {
        
        var img: UIImage?
        
        guard let url = URL.init(string: getPhotoURL(urlString)) else {
            return nil
        }
        let resource = KF.ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: [
            .requestModifier(ImageLoadManager.shared.getModifier()),
            .transition(.fade(1.0))
            
        ], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                img = value.image
            case .failure(let error):
                debugPrint("[IMAGE DOWNLOAD ERROR] ", error)
                img = nil
            }
        }
        
        return img
    }
    
    // 서버에서 받을 이미지 full url
    private func getPhotoURL(_ url: String) -> String {
        return BaseURL.baseURL + "/" + url
    }
    
    
    
}
