//
//  CategoryCell.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import UIKit

import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let id = "CategoryCell"
    var imageView = UIImageView()
    var titleLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setting()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLbl.text = nil
    }
    
    private func setting() {
        imageView.contentMode = .scaleAspectFit
        
        self.addSubviews([imageView, titleLbl])
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func setData(_ index: Int) {
        self.titleLbl.text = MealType.allCases[index].description
        self.imageView.image = UIImage(named: MealType.allCases[index].rawValue)
    }
}

