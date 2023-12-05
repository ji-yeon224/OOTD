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
        
        self.kf.indicatorType = .activity
        guard let url = URL(string: getPhotoURL(urlString)) else { return }
        self.kf.setImage(with: url, options: [
            .requestModifier(ImageLoadManager.shared.getModifier()),
            .transition(.fade(1.0))
        ]) { result in
            switch result {
            case .success(let result):
                self.image = result.image.resize(size: width)
                
            case .failure(_):
                self.image = Constants.Image.photo?.withTintColor(Constants.Color.placeholder)
                
                
            }
            
        }
        
    }
    
//    func setImage(with urlString: String, resize width: CGFloat) {
//        self.kf.indicatorType = .activity
//        ImageCache.default.retrieveImage(forKey: getPhotoURL(urlString), options: nil) { result in
//            switch result {
//            case .success(let value):
//                if let image = value.image {
//                    //캐시가 존재하는 경우
//                    print("cache", urlString)
//                    self.image = image.resize(width: width)
//                } else {
//                    //캐시가 존재하지 않는 경우
//                    print("cache x")
//                    guard let url = URL(string: self.getPhotoURL(urlString)) else { return }
//                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
//                    self.kf.setImage(
//                        with: resource,
//                        options: [
//                            .requestModifier(ImageLoadManager.shared.getModifier()),
//                            .transition(.fade(1.0))
//                            
//                        ]) { [weak self] result in
//                            guard let self = self else { return }
//                            switch result {
//                            case .success(let data):
//                                self.image = data.image.resize(size: width)
//                            case .failure(_):
//                                self.image = UIImage(systemName: "person")
//                            }
//                        }
//                }
//            case .failure(let error):
//                print("[IMAGE ERROR]", error)
//            }
//        }
//    }
//    
    // 서버에서 받을 이미지 full url
    private func getPhotoURL(_ url: String) -> String {
        return BaseURL.baseURL + "/" + url
    }
    
}
