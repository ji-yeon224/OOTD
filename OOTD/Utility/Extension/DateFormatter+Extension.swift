//
//  DateFormatter+Extension.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

extension DateFormatter {
    
    static let format = {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        format.dateFormat = "yyyyMMdd"
        return format
    }()
    
    static let textFieldFormat = {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        format.dateFormat = "yyyy.MM.dd"
        return format
    }()
    
    static func convertToString(format: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    
    static func convertDate(date: Date) -> String {
        return format.string(from: date)
    }
    
    static func convertTextFieldDate(date: Date) -> String {
        return textFieldFormat.string(from: date)
    }
    
    static func stringToDate(date: String) -> Date {
        return format.date(from: date) ?? Date()
    }
}
