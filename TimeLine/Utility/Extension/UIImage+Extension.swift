//
//  UIImage+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 11/28/23.
//

import UIKit

extension UIImage {
    func resize(size: CGFloat) -> UIImage {
        var scale: CGFloat
        var newHeight: CGFloat
        var newWidth: CGFloat
        if self.size.width > self.size.height {
            newHeight = size
            scale = size / self.size.height
            newWidth = self.size.width * scale
        } else {
            newWidth = size
            scale = size / self.size.width
            newHeight = self.size.height * scale
        }
        print(newWidth, newHeight)

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    func resize(multiplier: CGFloat) -> UIImage {
        let newWidth = self.size.width * multiplier
        let newHeight = self.size.height * multiplier

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
