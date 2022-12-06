//
//  SearchView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/19.
//

import UIKit

import SnapKit

class SearchView: UIView {
    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            imageView.isHidden = newValue == nil
            updateConstraint(newValue == nil)
            self.imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var placeholder: String? {
        get {
            return searchTextField.placeholder
        }
        set {
            searchTextField.placeholder = newValue
        }
    }
    
    var imageColor: UIColor {
        get {
            return self.imageView.tintColor
        }
        set {
            self.imageView.tintColor = newValue
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    var searchTextField = UITextField()
    private var imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        self.backgroundColor = .lightGray
        self.imageView.tintColor = .black
        searchTextField.returnKeyType = .search
        searchTextField.placeholder = placeholder ?? "검색하세요."
        searchTextField.textColor = .black
        self.addSubviews([imageView, searchTextField])
    }
    
    func autoLayout() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
        }
    }
    
    func updateConstraint(_ asd: Bool) {
        self.searchTextField.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(asd ? 13 : 33)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
        }
        super.updateConstraints()
    }
}
