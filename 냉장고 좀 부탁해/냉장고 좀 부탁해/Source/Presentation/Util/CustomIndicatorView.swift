//
//  CustomIndicatorView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/23.
//

import UIKit

import SnapKit

final class CustomIndicatorView: UIView {
    private let size = ScreenUtil.width / 7
    private var timer: Timer?
    private let imageArr = ["apple", "carrot", "eggplant", "spinach"]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    private lazy var imageBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = size
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.imageBaseView)
        self.imageBaseView.addSubview(imageView)
        
        self.contentView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.imageBaseView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
            $0.width.height.equalTo(size * 2)
        }
        
        self.imageView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
            $0.width.height.equalTo(size - 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        if !(UIApplication.shared.keyWindow?.subviews.contains(where: { $0 is CustomIndicatorView }) ?? false) {
            UIApplication.shared.keyWindow?.addSubview(self)
            
            self.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            self.layoutIfNeeded()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                guard let self = self else { timer.invalidate(); return }
                let imageIdx = Int(timer.fireDate.timeIntervalSince1970.truncatingRemainder(dividingBy: 4))
                let imageName = self.imageArr[safe: imageIdx]
                self.imageView.image = UIImage(named: imageName!)
                self.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.7, animations: { self.contentView.alpha = 1 })
        }
    }
    
    func stopAnimating() {
        self.removeFromSuperview()
        timer = nil
    }
}
