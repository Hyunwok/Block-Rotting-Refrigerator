//
//  MealCollectionViewCell.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/31.
//

import UIKit

final class MealCollectionViewCell: UICollectionViewCell {
    static let id = "MealCollectionViewCell"
    
    private var image: UIImage?
    private var mealID: String!
    private var imageView = UIImageView()
    private var mealNameLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        mealNameLbl.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.height.equalTo(23)
        }
    }
    
    private func setting() {
        imageView.contentMode = .scaleAspectFill
        mealNameLbl.font = .systemFont(ofSize: 18, weight: .heavy)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        mealNameLbl.adjustsFontSizeToFitWidth = true
        
        self.addSubviews([imageView, mealNameLbl])
    }
    
    func setData(_ data: FoodDetailResponseDTO) {
        mealNameLbl.text = data.strMeal
        self.mealID = data.idMeal
        
        DispatchQueue.global().async {
            guard let url = URL(string: data.strMealThumb),
                  let imageData = try? Data(contentsOf: url) else { self.imageView.image = UIImage(systemName: "photo"); return }
            DispatchQueue.main.async {
                if self.image == nil {
                    self.image = UIImage(data: imageData, scale: 0.8)
                }
                
                self.imageView.image = self.image
            }
        }
    }
}
