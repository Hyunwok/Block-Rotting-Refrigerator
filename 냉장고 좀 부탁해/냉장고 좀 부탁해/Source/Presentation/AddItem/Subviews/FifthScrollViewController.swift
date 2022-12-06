//
//  FifthScrollViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/08.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class FifthScrollViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let infoLbl = UILabel()
    let finishBtn = UIButton()
    private let countLbl = UILabel()
    private let plusBtn = UIButton()
    private let minusBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        bind()
    }
    
    func setting() {
        infoLbl.text = "마지막으로, 재료의 개수를 설정해주세요."
        infoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        infoLbl.textAlignment = .center
        
        countLbl.text = "1"
        countLbl.font = .systemFont(ofSize: 24, weight: .heavy)
        countLbl.textAlignment = .center
        
        plusBtn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        plusBtn.tintColor = .black
        plusBtn.backgroundColor = .customGreen
        plusBtn.layer.cornerRadius = 25
        
        minusBtn.setImage(UIImage(systemName: "minus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        minusBtn.tintColor = .black
        minusBtn.backgroundColor = .customGreen
        minusBtn.layer.cornerRadius = 25
        
        finishBtn.backgroundColor = .customYellow
        finishBtn.setTitleColor(.black, for: .normal)
        finishBtn.layer.cornerRadius = 25
        finishBtn.setTitle("재료 추가 끝내기", for: .normal)
        finishBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        
        self.view.addSubviews([infoLbl, countLbl, finishBtn, plusBtn, minusBtn])
    }
    
    func layout() {
        infoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(24)
        }
        
        finishBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(23)
            $0.height.equalTo(60)
        }
        
        countLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(20)
            $0.width.equalTo(ScreenUtil.width / 2)
        }
        
        plusBtn.snp.makeConstraints {
            $0.leading.equalTo(countLbl.snp.trailing)
            $0.top.equalTo(countLbl.snp.bottom).offset(50)
            $0.width.height.equalTo(50)
        }
        
        minusBtn.snp.makeConstraints {
            $0.trailing.equalTo(countLbl.snp.leading)
            $0.centerY.equalTo(plusBtn.snp.centerY)
            $0.width.height.equalTo(50)
        }
    }
    
    func bind() {
        Observable.merge(plusBtn.rx.tap.map { _ in 1 },
                         minusBtn.rx.tap.map { _ in -1 }
        ).bind {
            let currentNum = Int(self.countLbl.text ?? "0")!
            if currentNum + $0 >= 1 {
                self.countLbl.text = String(currentNum + $0)
            }
        }.disposed(by: disposeBag)
        
        finishBtn.rx.tap
            .bind {
                let cnt = Int(self.countLbl.text ?? "0")!
                event.onNext(.foodCnt(cnt))
            }.disposed(by: disposeBag)
    }
}
