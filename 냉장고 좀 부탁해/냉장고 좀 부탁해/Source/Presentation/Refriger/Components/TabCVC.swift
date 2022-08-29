//
//  TabCVC.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/19.
//

import UIKit

import SnapKit

enum FoodType: Int, CaseIterable {
    case cereals = 0 // 곡류
    case meat
    case seafood
    case fruits
    case vegetables
    case dairyProductAndEggs // 유제품
    case artefact // 가공품
    case condiment // 조미료, 장류
    case sideDish // 반찬류
    case none
}

extension FoodType: CustomStringConvertible {
    var description: String {
        switch self {
        case .meat:
            return "육류"
        case .vegetables:
            return "채소류"
        case .cereals:
            return "곡류"
        case .fruits:
            return "과일류"
        case .dairyProductAndEggs:
            return "유제품 / 난류"
        case .seafood:
            return "해산물류"
        case .artefact:
            return "가공품"
        case .condiment:
            return "조미료 / 장류"
        case .sideDish:
            return "반찬류"
        case .none:
            return "검색 결과"
        }
    }
}

final class TabCVC: UICollectionViewCell {
    static let cellID = "TabCVC"
    
    var seperateColor: UIColor {
        get {
            return seperateView.backgroundColor!
        }
        set {
            seperateView.backgroundColor = newValue
        }
    }
    
    override var isSelected: Bool {
        willSet {
            titleLbl.textColor = !newValue ? .tabNotSelected : .label
            seperateView.isHidden = !newValue
        }
    }
    
    private var titleLbl = UILabel()
    private var seperateView = UIView()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        seperateView.isHidden = true
    }
    
    // MARK: - Layout
    private func setting() {
        self.clipsToBounds = true
        seperateView.isHidden = true
        seperateView.backgroundColor = .label
        titleLbl.numberOfLines = 1
        titleLbl.textColor = .lightGray
        titleLbl.textAlignment = .center
        titleLbl.font = .systemFont(ofSize: 17, weight: .heavy)
        
        self.addSubviews([titleLbl, seperateView])
    }
    
    private func layout() {
        titleLbl.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(8.5)
//            $0.height.equalTo(58)
        }
        
        seperateView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).offset(8.5)
            $0.height.equalTo(2)
        }
    }
    
    func setData(_ data: TextData) {
        titleLbl.text = data
    }
}

typealias TextData = String

