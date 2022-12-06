//
//  ScreenUtil.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

struct ScreenUtil {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var topSafeArea: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    }
    
    static var bottomSafeArea: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 34
    }
}
