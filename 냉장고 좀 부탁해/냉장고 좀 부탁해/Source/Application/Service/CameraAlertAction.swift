//
//  CameraAlertAction.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/11.
//

import UIKit

enum CameraAlertAction: AlertActionType {
    case camera
    case upload
    case cancel
    
    var title: String? {
        switch self {
        case .camera: return "사진 찍기"
        case .upload: return "사진 선택하기"
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
