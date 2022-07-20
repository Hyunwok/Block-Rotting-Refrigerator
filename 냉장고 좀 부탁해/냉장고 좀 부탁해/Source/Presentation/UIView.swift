//
//  UIView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/19.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerClassCell<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = "\(cellType)"
        register(cellType, forCellReuseIdentifier: identifier)
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
