//
//  String+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 12/6/23.
//

import Foundation

extension String {
    static func convertToDate(format: String, date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = format
        return formatter.date(from: date)
    }
    
    // 서버에서 받은 데이터 포멧 변경하기
    static func convertDateFormat(date: String) -> String {
        if let dateType = String.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: date) {
            return DateFormatter.convertToString(format: "yyyy.MM.dd a hh:mm", date: dateType)
            
        }
        
        return ""
    }
}
