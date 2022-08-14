//
//  UIColor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/27.
//

import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: Double) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static var tabNotSelected: UIColor {
        return UIColor(named: "tabNotSelected")!
    }
    
    static var addBtnColor: UIColor {
        return UIColor(named: "addBtnColor")!
    }
    
    static var customGreen: UIColor {
        return UIColor(named: "customGreen")!
    }
    
    static var customYellow: UIColor {
        return UIColor(named: "customYellow")!
    }
}
