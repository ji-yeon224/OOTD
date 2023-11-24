//
//  UIImageView+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 11/24/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        self.kf.indicatorType = .activity
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    //캐시가 존재하는 경우
                    self.image = image
                } else {
                    //캐시가 존재하지 않는 경우
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(
                        with: resource,
                        options: [
                            .requestModifier(ImageLoadManager.shared.getModifier()),
                            .transition(.fade(1.0))
                            
                        ]) { result in
                            switch result {
                            case .success(let data):
                                self.image = data.image
                            case .failure(_):
                                self.image = UIImage(systemName: "person")
                            }
                        }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
