//
//  ItemCVC.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

import SnapKit

final class ItemCVC: UICollectionViewCell {
    static let cellID = "ItemCVC"
    
    private var emptyImageView = UIImageView()
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
        emptyImageView.image = UIImage(systemName: "xmark.bin.fill")!.withRenderingMode(.alwaysTemplate)
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.tintColor = .customGreen
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .rgb(36, 54, 60, 0.1)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (self.frame.width - 10) / 10
        
        placeImageView.tintColor = .systemBackground
//        placeImageView.layer.cornerRadius = 15
//        placeImageView.backgroundColor = .rgb(36, 54, 60, 0.2)
        placeImageView.contentMode = .scaleAspectFit
        
        numberLbl.isHidden = true
        dateLbl.font = .systemFont(ofSize: 14)
        dateLbl.textColor = .black.withAlphaComponent(0.7)
        
        self.addSubviews([imageView, placeImageView, numberLbl, nameLbl, dateLbl])
        self.imageView.addSubview(emptyImageView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(5)
//            $0.bottom.equalTo(nameLbl.snp.top).offset(-8)
            $0.height.equalTo(imageView.snp.width)
            //            $0.height.equalTo((ScreenUtil.width - 45) / 2)
        }
        
        nameLbl.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading)
            $0.height.equalTo(20.33)
                        $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        placeImageView.snp.makeConstraints {
            $0.bottom.equalTo(imageView).offset(-5)
            $0.leading.equalTo(imageView).offset(5)
            $0.width.height.equalTo(30)
        }
        
        dateLbl.snp.makeConstraints {
            $0.height.equalTo(20.33)
            $0.leading.trailing.equalTo(nameLbl)
            $0.top.equalTo(nameLbl.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
        
        numberLbl.snp.makeConstraints {
            $0.trailing.equalTo(imageView).offset(10)
            $0.top.equalTo(imageView).offset(5)
            $0.width.height.equalTo(30)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.leading.equalToSuperview().inset(30)
        }
    }
    
    func setting(_ food: FoodItem?) {
        guard let item = food else { return }
        self.imageView.image = item.itemImage
        self.placeImageView.image = UIImage(systemName: item.itemPlace.description)?.withRenderingMode(.alwaysTemplate)
        self.emptyImageView.isHidden = item.itemImage == nil ? false : true
        self.numberLbl.text = "X\(item.number)"
        self.numberLbl.isHidden = item.number > 1 ? false : true
        self.nameLbl.text = item.name
        
        var text = ""
        if item.remainingDay == 10000 {
            text = "알 수 없음"
        } else if item.remainingDay < 0 {
            text = "D-\(-1 * item.remainingDay)"
        } else if item.remainingDay < 1 {
            text = "D-Day"
        } else if item.remainingDay > 30 {
            text = "D-30"
        } else {
            text = "D-\(item.remainingDay)"
        }
        self.dateLbl.text = text
    }
}
