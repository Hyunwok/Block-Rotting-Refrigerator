//
//  AddNameAndImageView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import SnapKit
import RxCocoa
import ReactorKit

final class AddNameAndImageView: UIView, View {
    var disposeBag = DisposeBag()
    
    let imageBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = ScreenUtil.width / 30
        btn.backgroundColor = .lightGray.withAlphaComponent(0.7)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    let plusImageBtn: UIButton = {
        let btn = UIButton()
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage(systemName: "xmark")!.withRenderingMode(.alwaysTemplate), for: .selected)
        btn.layer.cornerRadius = 20
        btn.backgroundColor = .addBtnColor
        btn.tintColor = .white
        return btn
    }()
    
    let nameTextField: SearchView = {
        let txtField = SearchView()
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.backgroundColor = .white
        txtField.placeholder = "재료이름을 적어주세요."
        txtField.layer.cornerRadius = 15
        txtField.image = nil
        return txtField
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 25
        btn.setTitle("재료 추가", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        return btn
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.tintColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    convenience init(reactor: AddNameAndImageReactor) {
        defer { self.reactor = reactor }
        self.init()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layout() {
        self.addSubviews([imageBtn, plusImageBtn, nameTextField, nextBtn])
        imageBtn.addSubview(imageView)
        
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
}

extension AddNameAndImageView {
    func bind(reactor: AddNameAndImageReactor) {
        nameTextField.searchTextField.rx.text
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind { [weak self] text in
                self?.nextBtn.isEnabled = !(text.isEmpty) || !(text == "")
                self?.nextBtn.backgroundColor = self?.nextBtn.isEnabled ?? false ? .customYellow : .lightGray
            }.disposed(by: disposeBag)
        
        plusImageBtn.rx.tap
            .bind { [weak self] _ in
                self?.plusImageBtn.isSelected = false
                self?.imageView.isHidden = false
                self?.imageBtn.setImage(nil, for: .normal)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map(\.image)
            .compactMap { $0 }
            .distinctUntilChanged()
            .map { [weak self] image in
                self?.imageView.isHidden = true
                self?.plusImageBtn.isSelected = true
                return image
            }
            .bind(to: imageBtn.rx.image(for: .normal))
            .disposed(by: disposeBag)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
