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
        //print(newWidth, newHeight)
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    func resize(multiplier: CGFloat) -> UIImage {
        let newWidth = self.size.width * multiplier/100
        let newHeight = self.size.height * multiplier/100
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
    func resize(width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let height = self.size.height * scale
        //        print(width, height)
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { [weak self] context in
            guard let self = self else { return }
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
    func resizeV3(to size: CGFloat) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: size * 3,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        guard
            let data = jpegData(compressionQuality: 1.0),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }
        
        let resizedImage = UIImage(cgImage: cgImage)
        return resizedImage
    }
}
