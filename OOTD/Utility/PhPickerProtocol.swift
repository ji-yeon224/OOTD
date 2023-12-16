//
//  PhPickerProtocol.swift
//  TimeLine
//
//  Created by 김지연 on 11/26/23.
//

import Foundation
import PhotosUI

protocol PhPickerProtocol: AnyObject {
    func didFinishPicking(picker: PHPickerViewController, results: [PHPickerResult])
}
