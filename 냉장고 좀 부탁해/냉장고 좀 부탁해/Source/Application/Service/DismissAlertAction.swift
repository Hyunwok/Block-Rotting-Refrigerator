//
//  DismissAlertAction.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/11.
//

import UIKit

enum DismissAlertAction: AlertActionType {
    case `continue`
    case cancel
    
    var title: String? {
        switch self {
        case .continue: return "계속하기"
        case .cancel: return "나가기"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .cancel: return .cancel
        default: return .default
        }
    }
}

enum OkAlertAction: AlertActionType {
    case ok
    
    var title: String? {
        switch self {
        case .ok: return "확인"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .ok: return .default
        }
    }
}

enum YesOrNoAlertAction: AlertActionType {
    case yes
    case no
    
    var title: String? {
        switch self {
        case .yes: return "예"
        case .no: return "아니요"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .no: return .default
        case .yes: return .destructive
        }
    }
}
