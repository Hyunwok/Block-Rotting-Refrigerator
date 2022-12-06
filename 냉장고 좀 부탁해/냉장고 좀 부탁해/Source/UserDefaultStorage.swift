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
        case remainDay
        case lastStartDate
    }
    
    var isFirstLaunch: Bool {
        get { return userDefaults?.bool(forKey: Keys.isFirstLanch.rawValue) ?? true }
        set { userDefaults?.set(newValue, forKey: Keys.isFirstLanch.rawValue) }
    }
    
    var remainDay: Int {
        get { return userDefaults?.integer(forKey: Keys.remainDay.rawValue) ?? 1 }
        set { userDefaults?.set(newValue, forKey: Keys.remainDay.rawValue) }
    }
    
    var lastStartDate: Date {
        get { return (userDefaults?.object(forKey: Keys.lastStartDate.rawValue) as? Date) ?? Date() }
        set { userDefaults?.set(newValue, forKey: Keys.lastStartDate.rawValue) }
    }
}
