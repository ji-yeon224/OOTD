//
//  UserDefaultsHelper.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

@propertyWrapper
struct Defaults<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultsHelper {
    
//    static let shared = UserDefaultsHelper()
    private init() { }
    
//    private let userDefalts = UserDefaults.standard
    
    enum Key: String {
        case token
        case refreshToken
        case isLogin
    }
    @Defaults(key: Key.token.rawValue, defaultValue: "") static var token
    @Defaults(key: Key.refreshToken.rawValue, defaultValue: "") static var refreshToken
    @Defaults(key: Key.isLogin.rawValue, defaultValue: false) static var isLogin

    
    static func initToken() {
        UserDefaultsHelper.token = ""
        UserDefaultsHelper.refreshToken = ""
        UserDefaultsHelper.isLogin = false
    }
    
    
}
