//
//  FirstScrollViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

enum FoodEvent {
    case updateImage(UIImage)
    case foodName(String)
    case foodPlace(ItemPlace)
    case remainDay(Int)
    case foodCnt(Int)
    case addType(FoodType)
}

final class FirstScrollViewController: UIViewController {
    let disposeBag = DisposeBag()
    let imageBtn = UIButton()
    let plusImageBtn = UIButton()
    let nameTextField = SearchView()
    let nextBtn = UIButton()
    let imageView = UIImageView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        bind()
    }
    
    // MARK: - Layout
    private func setting() {
        imageBtn.layer.cornerRadius = ScreenUtil.width / 30
        imageBtn.backgroundColor = .lightGray.withAlphaComponent(0.7)
        imageBtn.imageView?.contentMode = .scaleAspectFill
        imageBtn.clipsToBounds = true
        
        imageView.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black.withAlphaComponent(0.7)
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.backgroundColor = .white
        nameTextField.placeholder = "재료이름을 적어주세요."
        nameTextField.layer.cornerRadius = 15
        nameTextField.image = nil
        
        plusImageBtn.layer.borderColor = UIColor.white.cgColor
        plusImageBtn.layer.borderWidth = 1
        plusImageBtn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        plusImageBtn.layer.cornerRadius = 20
        plusImageBtn.backgroundColor = .addBtnColor
        plusImageBtn.tintColor = .white
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .lightGray
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.layer.cornerRadius = 25
        nextBtn.setTitle("재료 추가", for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        
        self.view.addSubviews([imageBtn, plusImageBtn, nameTextField, nextBtn])
        imageBtn.addSubview(imageView)
    }
    
    private func layout() {
        imageBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(15)
            $0.height.width.equalTo(ScreenUtil.width / 3)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ScreenUtil.width / 12)
        }
        
        plusImageBtn.snp.makeConstraints {
            $0.trailing.equalTo(imageBtn.snp.trailing).offset(10)
            $0.bottom.equalTo(imageBtn.snp.bottom).offset(10)
            $0.width.height.equalTo(40)
        }
        
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(plusImageBtn.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
        
        nextBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
            $0.leading.equalTo(nameTextField.snp.leading)
            $0.height.equalTo(60)
        }
    }
    
    func bind() {
        nameTextField.searchTextField.rx.text
            .map { $0 ?? "" }
            .bind {
                self.nextBtn.backgroundColor = self.nextBtn.isEnabled ? .customYellow : .lightGray
                self.nextBtn.isEnabled = !($0.isEmpty) || !($0 == "")
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind {
                event.onNext(.foodName(self.nameTextField.searchTextField.text ?? ""))
            }.disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
