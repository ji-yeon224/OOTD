//
//  UIImageView+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String, resize width: CGFloat) {
        let cornerImageProcessor = RoundCornerImageProcessor(cornerRadius: 15)
        
        ImageCache.default.retrieveImage(forKey: urlString, options: [
            .requestModifier(ImageLoadManager.shared.getModifier()),
            .transition(.fade(1.0)),
            .processor(cornerImageProcessor)
        ]) { [weak self] result in
            guard let self = self else { return }
            self.kf.indicatorType = .activity
            switch result {
            case .success(let value):
                
                if let image = value.image {
                    self.image = image.resize(width: width)
                } else {
                    guard let url = URL(string: self.getPhotoURL(urlString)) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource, options: [
                        .requestModifier(ImageLoadManager.shared.getModifier()),
                        .transition(.fade(1.0)),
                        .processor(cornerImageProcessor)
                    ]) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let result):
                            self.image = result.image.resize(width: width)
                            
                        case .failure(_):
                            self.image = Constants.Image.errorPhoto?.withTintColor(Constants.Color.placeholder)
                            
                            
                        }
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
    
    
//    func setImage(with urlString: String, resize width: CGFloat) {
//        let cornerImageProcessor = RoundCornerImageProcessor(cornerRadius: 15)
//        self.kf.indicatorType = .activity
//        guard let url = URL(string: getPhotoURL(urlString)) else { return }
//        self.kf.setImage(with: url, options: [
//            .requestModifier(ImageLoadManager.shared.getModifier()),
//            .transition(.fade(1.0)),
//            .processor(cornerImageProcessor)
//        ]) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let result):
//                self.image = result.image.resize(width: width) //result.image.resize(width: width)
//                
//            case .failure(_):
//                self.image = Constants.Image.photo?.withTintColor(Constants.Color.placeholder)
//                
//                
//            }
//            
//        }
//        
//    }
    
    
 
    
    // 서버에서 받을 이미지 full url
    private func getPhotoURL(_ url: String) -> String {
        return BaseURL.baseURL + "/" + url
    }
    
}
