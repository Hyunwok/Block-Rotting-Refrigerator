//
//  UserDefaultStorage.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/01.
//

import Foundation

class UserDefaultStorage {
    static let shared = UserDefaultStorage()
    private let name = "Block-Rotting-Refrigerator"
    private lazy var userDefaults = UserDefaults(suiteName: name)
    
    init() {}
    
    enum Keys: String {
        case isFirstLanch
    }
    
    var isFirstLaunch: Bool {
        get { return userDefaults?.bool(forKey: Keys.isFirstLanch.rawValue) ?? false }
        set { userDefaults?.set(newValue, forKey: Keys.isFirstLanch.rawValue) }
    }
}
