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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting() {
        self.addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setText(_ text: TextData) {
        titleLbl.text = text
    }
}
