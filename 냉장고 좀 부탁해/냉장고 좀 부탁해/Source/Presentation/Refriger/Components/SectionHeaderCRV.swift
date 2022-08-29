//
//  SectionHeaderCRV.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

import SnapKit

final class SectionHeaderCRV: UICollectionReusableView {
    private let titleLbl = UILabel()
    private let underBarView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting() {
        self.addSubviews([titleLbl, underBarView])
        
        titleLbl.font = .systemFont(ofSize: 17, weight: .heavy)
        underBarView.backgroundColor = .label
        
        titleLbl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(35)
            $0.centerY.equalToSuperview()
        }
        
        underBarView.snp.makeConstraints {
            $0.leading.equalTo(titleLbl.snp.trailing).offset(15)
            $0.height.equalTo(4)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func setText(_ text: TextData) {
        titleLbl.text = text
    }
}
