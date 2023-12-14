//
//  Data+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 12/13/23.
//

import Foundation

extension Data {
    var convertToMb: String {
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(self.count))
        
    }
    
}
