//
//  ItemCVC.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

import SnapKit

final class ItemCVC: UICollectionViewCell {
    private var imageView = UIImageView()
    private var nameLbl = UILabel()
    private var dateLbl = UILabel()
    private var numberLbl = UILabel()
    private var placeImageView = UIImageView()
    
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
        imageView.image = nil
        nameLbl.text = nil
        dateLbl.text = nil
        numberLbl.text = nil
        placeImageView.image = nil
        numberLbl.isHidden = true
    }
    
    private func setting() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (self.frame.width - 10) / 10
        placeImageView.layer.borderWidth = 2
        placeImageView.layer.borderColor = UIColor.black.cgColor
        placeImageView.clipsToBounds = true
        placeImageView.layer.cornerRadius = 15
        numberLbl.isHidden = true
        
        self.addSubviews([imageView, placeImageView, numberLbl, nameLbl, dateLbl])
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(5)
            $0.height.equalTo((ScreenUtil.width - 45) / 2)
        }
        
        nameLbl.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading)
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        numberLbl.snp.makeConstraints {
            $0.trailing.equalTo(imageView).offset(10)
            $0.top.equalTo(imageView).offset(5)
            $0.width.height.equalTo(30)
        }
        
        placeImageView.snp.makeConstraints {
            $0.bottom.equalTo(imageView).offset(-5)
            $0.leading.equalTo(imageView).offset(5)
            $0.width.height.equalTo(30)
        }
        
        dateLbl.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLbl)
            $0.top.equalTo(nameLbl.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setting(_ item: FoodItem) {
        self.imageView.image = item.itemImage
        self.placeImageView.image = UIImage(named: item.itemPlace.rawValue)
        self.numberLbl.text = "X\(item.number)"
        self.numberLbl.isHidden = item.number > 1 ? false : true
        self.nameLbl.text = item.name
        self.dateLbl.text = item.remainingDay < 1 ? "하루 미만" : "\(item.remainingDay)일 남음"
    }
}

extension ItemCVC: Reusable {} 
