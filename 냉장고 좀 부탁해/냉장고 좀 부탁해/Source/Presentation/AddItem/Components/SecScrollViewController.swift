//
//  SecScrollViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SecScrollViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    let infoLbl = UILabel()
    let sliderView = UISlider()
    let imageView = UIImageView()
    let dayLbl = UILabel()
    let dayInfoLbl = UILabel()
    let notSureBtn = UIButton()
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
        sliderView.maximumTrackTintColor = .customGreen.withAlphaComponent(0.7)
        sliderView.minimumTrackTintColor = .addBtnColor
        notSureBtn.setTitleColor(.label.withAlphaComponent(0.6), for: .normal)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "remainDay")!
        dayLbl.text = "1"
        dayInfoLbl.text = "일 미만"
        dayLbl.font = .systemFont(ofSize: 24, weight: .heavy)
        dayInfoLbl.font = .systemFont(ofSize: 18, weight: .heavy)
        notSureBtn.setTitle("잘 모르겠어요", for: .normal)
        notSureBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        nextBtn.layer.cornerRadius = 25
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.backgroundColor = .customYellow
        sliderView.maximumValue = 31
        sliderView.minimumValue = 0
        
        self.view.addSubviews([infoLbl, imageView, dayLbl, dayInfoLbl, sliderView, notSureBtn, nextBtn])
    }
    
    func layout() {
        infoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            
            $0.top.greaterThanOrEqualTo(infoLbl.snp.bottom).offset(30)
            $0.centerY.equalToSuperview().offset(-(ScreenUtil.height / 10))
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(23)
            $0.bottom.greaterThanOrEqualTo(dayLbl.snp.top).offset(30).priority(.high)
            // 슬라이더 랑 라벨 차이가 30 으로 이하로 되려고 한다면 얘는 두고
            // 라벨과 버튼 사이의 간격을 좁히는 그런 계획
//            $0.height.equalTo(imageView.snp.width)
        }
        
        dayLbl.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview().offset(-30)
            $0.bottom.greaterThanOrEqualTo(sliderView.snp.top).offset(-25).priority(.high)
            $0.bottom.lessThanOrEqualTo(sliderView.snp.top).offset(-40).priority(.high)
        }
        
        dayInfoLbl.snp.makeConstraints {
            $0.centerY.equalTo(dayLbl.snp.centerY)
            $0.leading.equalTo(dayLbl.snp.trailing).offset(8)
        }
        
        sliderView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(notSureBtn.snp.top).offset(-25).priority(.medium)
//            $0.bottom.lessThanOrEqualTo(notSureBtn.snp.top).offset(-40).priority(.medium)
        }
        
        notSureBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalTo(self.view.snp.centerX).offset(-(ScreenUtil.width / 4))
        }
        
        nextBtn.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(self.nextBtn.intrinsicContentSize.width + 40)
            $0.centerY.equalTo(notSureBtn)
            $0.centerX.equalTo(self.view.snp.centerX).offset(ScreenUtil.width / 4)
        }
    }
    
    func bind() {
        sliderView.rx.value
            .bind {
                if $0 < 1 {
                    self.dayLbl.text = "1"
                    self.dayInfoLbl.text = "일 미만"
                } else if $0 == 31 {
                    self.dayLbl.text = "30"
                    self.dayInfoLbl.text = "일 이상"
                } else {
                    self.dayLbl.text = String(Int($0))
                    self.dayInfoLbl.text = "일"
                }
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind {
                event.onNext(.remainDay(Int(self.sliderView.value)))
            }.disposed(by: disposeBag)
        
        notSureBtn.rx.tap
            .bind {
                event.onNext(.remainDay(-1))
            }.disposed(by: disposeBag)
    }
}
