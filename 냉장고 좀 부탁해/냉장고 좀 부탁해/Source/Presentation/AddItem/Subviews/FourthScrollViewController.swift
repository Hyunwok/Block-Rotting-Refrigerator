//
//  FourthScrollViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import SnapKit
import RxSwift

final class FourthScrollViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let infoLbl = UILabel()
    private let typeInfoLbl = UILabel()
    private let pickerView = UIPickerView()
    let nextBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        bind()
    }
    
    func setting() {
        infoLbl.text = "재료의 유통기한이 얼마나 남았나요?"
        infoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        infoLbl.textAlignment = .center
        
        typeInfoLbl.text = "종류를 선택해주세요."
        typeInfoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        typeInfoLbl.textColor = .addBtnColor
        typeInfoLbl.textAlignment = .center
        
        nextBtn.backgroundColor = .customYellow
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.layer.cornerRadius = 25
        nextBtn.setTitle("다음으로", for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        
        self.view.addSubviews([infoLbl, typeInfoLbl, pickerView, nextBtn])
    }
    
    func layout() {
        infoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(24)
        }
        
        typeInfoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(23)
            $0.bottom.equalTo(pickerView.snp.top).offset(-30)
        }
        
        pickerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(23)
            $0.height.greaterThanOrEqualTo(216)
        }
        
        nextBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(23)
            $0.height.equalTo(60)
        }
    }
    
    func bind() {
        pickerView.rx.itemSelected
            .bind {
//                print(FoodType.allCases[$0.row])
                event.onNext(.addType(FoodType.allCases[$0.row]))
            }.disposed(by: disposeBag)
        
        Observable.of(FoodType.allCases)
            .map { tabs -> [FoodType] in
                var newTabs = tabs
                newTabs.removeLast()
                return newTabs
            }.bind(to: pickerView.rx.itemTitles) { row, _ in
                return FoodType.allCases[row].description
            }.disposed(by: disposeBag)
    }
}
