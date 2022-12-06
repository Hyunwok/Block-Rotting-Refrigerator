//
//  RemainDayView.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/03.
//

import UIKit

import SnapKit
import RxCocoa
import ReactorKit

final class RemainDayView: UIView, View {
    var disposeBag = DisposeBag()
    
    let sliderView: UISlider = {
        let view = UISlider()
        view.maximumTrackTintColor = .customGreen.withAlphaComponent(0.7)
        view.minimumTrackTintColor = .addBtnColor
        view.maximumValue = 31
        view.minimumValue = 1
        return view
    }()
    
    let nextBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        btn.layer.cornerRadius = 25
        btn.setTitle("다음", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .customYellow
        return btn
    }()
    
    let notSureBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label.withAlphaComponent(0.6), for: .normal)
        btn.setTitle("잘 모르겠어요", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        return btn
    }()
    
    private let infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "재료의 유통기한이 얼마나 남았나요?"
        lbl.font = .systemFont(ofSize: 20, weight: .heavy)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let dayInfoLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "일 미만"
        lbl.font = .systemFont(ofSize: 18, weight: .heavy)
        return lbl
    }()
    
    private let dayLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "1"
        lbl.font = .systemFont(ofSize: 24, weight: .heavy)
        return lbl
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "remainDay")!
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.addSubviews([infoLbl, imageView, dayLbl, dayInfoLbl, sliderView, notSureBtn, nextBtn])
        
        infoLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(infoLbl.snp.bottom).offset(30)
            $0.centerY.equalToSuperview().offset(-(ScreenUtil.height / 10))
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtil.width / 4.5)
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
            $0.centerX.equalTo(self.snp.centerX).offset(-(ScreenUtil.width / 4))
        }
        
        nextBtn.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(self.nextBtn.intrinsicContentSize.width + 40)
            $0.centerY.equalTo(notSureBtn)
            $0.centerX.equalTo(self.snp.centerX).offset(ScreenUtil.width / 4)
        }
    }
}

extension RemainDayView {
    func bind(reactor: RemainDayReactor) {
        sliderView.rx.value
            .map { Reactor.Action.slided($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { ($0.dayStr, $0.infoStr) }
            .bind { [weak self] strings in
                self?.dayLbl.text = strings.0
                self?.dayInfoLbl.text = strings.1
            }.disposed(by: disposeBag)
    }
}
