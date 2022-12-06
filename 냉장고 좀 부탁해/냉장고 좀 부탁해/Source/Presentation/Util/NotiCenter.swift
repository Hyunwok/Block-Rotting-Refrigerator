//
//  NotiCenter.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/09/28.
//

import UIKit

final class NotiCenter {
    static let shared = NotiCenter()
    
    private init() { }
    
    func addNoti(with food: FoodItem) {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "\(food.name)의 기한이 \(UserDefaultStorage.shared.remainDay)일 남았습니다"
        
        var notiRemain = food.remainingDay - UserDefaultStorage.shared.remainDay
        
        if notiRemain < 1 {
            notiRemain = food.remainingDay
        }
        
        let goalDate = NSCalendar.current.date(byAdding: .day, value: notiRemain, to: Date()) ?? Date()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: goalDate.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: food.id,
            content: notiContent,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            print(error)
            print(#function)
        }
    }
    
    func deleteNoti(with food: FoodItem) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [food.id])
    }
    
    func updateNoti(with food: FoodItem) {
        deleteNoti(with: food)
        addNoti(with: food)
    }
}
