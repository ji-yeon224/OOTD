//
//  UserDefaultsHelper.swift
//  TimeLine
//
//  Created by 김지연 on 11/15/23.
//

import Foundation

final class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    private init() { }
    
    private let userDefalts = UserDefaults.standard
    
    enum Key: String {
        case token
        case refreshToken
        case isLogin
    }
    
    var token: String? {
        get {
            return userDefalts.string(forKey: Key.token.rawValue)
        }
        set {
            userDefalts.set(newValue, forKey: Key.token.rawValue)
        }
    }
    
    var refreshToken: String? {
        get {
            return userDefalts.string(forKey: Key.refreshToken.rawValue)
        }
        set {
            userDefalts.set(newValue, forKey: Key.refreshToken.rawValue)
        }
    }
    
    var isLogin: Bool {
        get {
            return userDefalts.bool(forKey: Key.isLogin.rawValue)
        }
        set {
            userDefalts.set(newValue, forKey: Key.isLogin.rawValue)
        }
    }
    
}
