//
//  UIView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/19.
//

import UIKit

import RealmSwift

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

extension UITableView {
    func registerClassCell<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = "\(cellType)"
        register(cellType, forCellReuseIdentifier: identifier)
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, with cellType: T.Type = T.self) -> T {
        let identifier = "\(cellType)"
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(identifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}

extension UICollectionView {
    func registerClassCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        let identifier = "\(cellType)"
        register(cellType, forCellWithReuseIdentifier: identifier)
    }
    
    func registerReusableView<T: UICollectionReusableView>(_ classType: T.Type) {
        let identifier = "\(classType)"
        register(classType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = "\(classType)"
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? T else { fatalError("Failed to dequeue a view with identifier \(identifier) matching type \(classType.self).")
        }
        
        return cell
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, with cellType: T.Type = T.self) -> T {
        let identifier = "\(cellType)"
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(identifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}

extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
