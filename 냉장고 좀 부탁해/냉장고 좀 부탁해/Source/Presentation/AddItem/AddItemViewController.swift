//
//  AddItemViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/02.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

let event = PublishSubject<FoodEvent>()

final class AddItemViewController: UIViewController, View {
    let first = FirstScrollViewController()
    let sec = SecScrollViewController()
    let third = ThirdScrollViewController()
    let fourth = FourthScrollViewController()
    let fifth = FifthScrollViewController()
    var disposeBag = DisposeBag()
    
    let indicatorView = UIActivityIndicatorView(style: .large)
    let backBtn = UIButton()
    let pageControl = UIPageControl()
    let scrollView = UIScrollView()
    let closeBtn = UIButton()
    
    init(_ reactor: AddItemReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    func setting() {
        self.view.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: 2700, height: ScreenUtil.height)
        backBtn.setImage(UIImage(systemName: "arrow.backward")!.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = .label
        closeBtn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.tintColor = .label
        pageControl.pageIndicatorTintColor = .customGreen.withAlphaComponent(0.7)
        pageControl.currentPageIndicatorTintColor = .customGreen
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        backBtn.isHidden = true
        indicatorView.isHidden = true
        
        self.view.addSubviews([scrollView, backBtn, closeBtn, pageControl, indicatorView])
        scrollView.addSubviews([first.view, sec.view, third.view, fourth.view, fifth.view])
    }
    
    func layout() {
        backBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        closeBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(23)
            $0.top.equalTo(backBtn.snp.top)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        first.view.snp.makeConstraints {
            $0.height.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
        }
        
        sec.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(first.view.snp.trailing)
        }
        
        third.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(sec.view.snp.trailing)
        }
        
        fourth.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(third.view.snp.trailing)
        }
        
        fifth.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(fourth.view.snp.trailing)
        }
        
    }
    
    func bind(reactor: AddItemReactor) {
        fifth.finishBtn.rx.tap
            .map {
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
            }
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.add }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        first.imageBtn.rx.tap
            .map { Reactor.Action.addingImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        closeBtn.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backBtn.rx.tap
            .bind {
                let offsetX = self.scrollView.contentOffset.x
                self.scrollView.setContentOffset(CGPoint(x: offsetX - ScreenUtil.width, y: 0), animated: true)
            }.disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .bind {
                self.pageControl.isHidden = !($0.x >= ScreenUtil.width)
                self.backBtn.isHidden = !($0.x >= ScreenUtil.width)
                self.backBtn.alpha = $0.x / 100
                self.pageControl.currentPage = Int($0.x / ScreenUtil.width) - 1
            }.disposed(by: disposeBag)
        
        Observable.merge(first.nextBtn.rx.tap.map { _ in ()},
                         sec.nextBtn.rx.tap.map { _ in ()},
                         sec.notSureBtn.rx.tap.map { _ in ()},
                         fourth.nextBtn.rx.tap.map { _ in ()})
        .throttle(RxTimeInterval.milliseconds(1500), scheduler: MainScheduler.instance)
        .bind { _ in
            let offsetX = self.scrollView.contentOffset.x
            self.scrollView.setContentOffset(CGPoint(x: offsetX + ScreenUtil.width, y: 0), animated: true)
        }.disposed(by: disposeBag)
        
        Observable.merge(third.frozenBtn.rx.tap.map { _ in ()},
                         third.coldBtn.rx.tap.map { _ in ()},
                         third.roomTepBtn.rx.tap.map { _ in ()})
        .bind { _ in
            let offsetX = self.scrollView.contentOffset.x
            self.scrollView.setContentOffset(CGPoint(x: offsetX + ScreenUtil.width, y: 0), animated: true)
        }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.food.itemImage }
            .filter { $0 != nil }
            .bind {
                self.first.imageView.isHidden = true
                self.first.imageBtn.setImage($0, for: .normal)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isAdding }
            .filter { $0 == false }
            .bind {
                self.indicatorView.isHidden = !$0
                self.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
    }
}

