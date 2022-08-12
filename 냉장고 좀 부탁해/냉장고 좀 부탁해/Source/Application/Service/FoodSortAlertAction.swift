//
//  FoodSortAlertAction.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/11.
//

import UIKit

enum FoodSortAlertAction: AlertActionType {
    case lessDay
    case moreDay
    case coldTem
    case roomTem
    case frozen
    case cancel
    
    var title: String? {
        switch self {
        case .lessDay: return "적은 날짜"
        case .moreDay: return "많은 날짜"
        case .coldTem: return "냉장"
        case .roomTem: return "실온"
        case .frozen: return "냉동"
        case .cancel: return "취소"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .cancel: return .cancel
        default: return .default
        }
    }
}
