//
//  CGImage+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 12/13/23.
//

import UIKit
import UniformTypeIdentifiers

extension CGImage {
    var isPNG: Bool {
        return (utType as String?) == UTType.png.identifier
    }
}
