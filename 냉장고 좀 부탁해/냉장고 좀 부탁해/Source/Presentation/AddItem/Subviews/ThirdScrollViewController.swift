//
//  ThirdScrollViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import SnapKit
import RxSwift

final class ThirdScrollViewController: UIViewController {
    let roomTepBtn = UIButton()
    let coldBtn = UIButton()
    let frozenBtn = UIButton()
    private let disposeBag = DisposeBag()
    private let infoLbl = UILabel()
    private lazy var btnArr = [roomTepBtn, coldBtn, frozenBtn]
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        bind()
    }
    
    private func setting() {
        infoLbl.text = "재료 보관은 어디에 하나요?"
        infoLbl.textAlignment = .center
        infoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        
        roomTepBtn.backgroundColor = .lightGray
        coldBtn.backgroundColor = .lightGray
        frozenBtn.backgroundColor = .lightGray
        
        roomTepBtn.tag = 0
        coldBtn.tag = 1
        frozenBtn.tag = 2
        
        roomTepBtn.layer.cornerRadius = 20
        coldBtn.layer.cornerRadius = 20
        frozenBtn.layer.cornerRadius = 20
        
        roomTepBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        coldBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        frozenBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        
        roomTepBtn.setTitleColor(.black, for: .normal)
        coldBtn.setTitleColor(.black, for: .normal)
        frozenBtn.setTitleColor(.black, for: .normal)
        
        roomTepBtn.setTitle("상온", for: .normal)
        coldBtn.setTitle("냉장", for: .normal)
        frozenBtn.setTitle("냉동", for: .normal)
        
        self.view.addSubviews([stackView, infoLbl])
        stackView.addArrangedSubviews([roomTepBtn, coldBtn, frozenBtn])
    }
    
    private func layout() {
        infoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.top.greaterThanOrEqualTo(infoLbl.snp.bottom).offset(30)
        }
        
        roomTepBtn.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        coldBtn.snp.makeConstraints {
            $0.height.equalTo(roomTepBtn)
        }
        
        frozenBtn.snp.makeConstraints {
            $0.height.equalTo(roomTepBtn)
        }
    }
    
    func bind() {
        Observable.merge(roomTepBtn.rx.tap.map { _ in self.roomTepBtn },
                         coldBtn.rx.tap.map { _ in self.coldBtn },
                         frozenBtn.rx.tap.map { _ in self.frozenBtn })
        .bind {
            self.btnArr.forEach { btn in
                btn.backgroundColor = .lightGray
                btn.isSelected = false
            }
            $0.backgroundColor = .customYellow
            $0.isSelected = true
            event.onNext(.foodPlace(ItemPlace(rawValue: $0.tag)!))
        }.disposed(by: disposeBag)
    }
}
