//
//  TabCVC.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/19.
//

import UIKit

import SnapKit

final class TabCVC: UICollectionViewCell {
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
            titleLbl.textColor = !newValue ? .lightGray : .black
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
        seperateView.isHidden = true
        seperateView.backgroundColor = .black
        titleLbl.textColor = .lightGray
        titleLbl.textAlignment = .center
        titleLbl.font = .systemFont(ofSize: 19, weight: .heavy)
        
        self.addSubviews([titleLbl, seperateView])
    }
    
    private func layout() {
        titleLbl.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        seperateView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom)
            $0.height.equalTo(2)
        }
    }
    
    func setData(_ data: TextData) {
        titleLbl.text = data
    }
}

typealias TextData = String

extension TabCVC: Reusable {}
