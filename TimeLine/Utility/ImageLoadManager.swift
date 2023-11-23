//
//  ImageLoadManager.swift
//  TimeLine
//
//  Created by 김지연 on 11/23/23.
//

import Foundation
import Kingfisher

final class ImageLoadManager {
    
    static let shared = ImageLoadManager()
    private init() { }
 
    func getModifier() -> AnyModifier {
        return AnyModifier { request in
            var r = request
            r.setValue(UserDefaultsHelper.token, forHTTPHeaderField: "Authorization")
            r.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            return r
        }
    }
}
