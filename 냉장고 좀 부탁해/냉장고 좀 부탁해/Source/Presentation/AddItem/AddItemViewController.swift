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

final class AddItemViewController: UIViewController, View {
    private let coordinator: AddItemCoordinatorProtocol
    var disposeBag = DisposeBag()
    
    private let addNameAndImageView = AddNameAndImageView()
    private let remainDayView = RemainDayView()
    let third = ThirdScrollViewController()
    let fourth = FourthScrollViewController()
    let fifth = FifthScrollViewController()
    
    let indicatorView = CustomIndicatorView()
    let backBtn = UIButton()
    let scrollView = UIScrollView()
    let closeBtn = UIButton()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .customGreen.withAlphaComponent(0.7)
        control.currentPageIndicatorTintColor = .customGreen
        control.numberOfPages = 4
        control.currentPage = 0
        return control
    }()
    
    init(_ reactor: AddItemReactor, _ coordinator: AddItemCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit AddItemViewController")
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
        backBtn.isHidden = true
        closeBtn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.tintColor = .label
        indicatorView.isHidden = true
    }
    
    func layout() {
        self.view.addSubviews([scrollView, backBtn, closeBtn, pageControl, indicatorView])
        scrollView.addSubviews([addNameAndImageView, remainDayView, third.view, fourth.view, fifth.view])
        
        backBtn.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.leading.equalToSuperview().inset(23)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
        }
        
        closeBtn.snp.makeConstraints {
            $0.width.height.equalTo(50)
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
        
        addNameAndImageView.snp.makeConstraints {
            $0.height.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
        }
        
        remainDayView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(addNameAndImageView.snp.trailing)
        }
        
        third.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtil.width)
            $0.leading.equalTo(remainDayView.snp.trailing)
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
        closeBtn.rx.tap
            .map { Reactor.Action.dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backBtn.rx.tap
            .bind { [weak self] _ in
                let offsetX = self?.scrollView.contentOffset.x ?? 0.0
                self?.scrollView.setContentOffset(CGPoint(x: offsetX - ScreenUtil.width, y: 0), animated: true)
            }.disposed(by: disposeBag)
        
        fifth.finishBtn.rx.tap
            .map { [weak self] _ in
                self?.indicatorView.startAnimating()
            }.delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.add }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .bind { [weak self] offset in
                self?.pageControl.isHidden = !(offset.x >= ScreenUtil.width)
                self?.backBtn.isHidden = !(offset.x >= ScreenUtil.width)
                self?.backBtn.alpha = offset.x / 100
                self?.pageControl.currentPage = Int(offset.x / ScreenUtil.width) - 1
            }.disposed(by: disposeBag)
        
        Observable.merge(
            Observable.merge(addNameAndImageView.nextBtn.rx.tap.map { _ in ()},
                                     remainDayView.nextBtn.rx.tap.map { _ in ()},
                                     remainDayView.notSureBtn.rx.tap.map { _ in ()},
                                     fourth.nextBtn.rx.tap.map { _ in ()}),
             Observable.merge(third.frozenBtn.rx.tap.map { _ in ()},
                                     third.coldBtn.rx.tap.map { _ in ()},
                                     third.roomTepBtn.rx.tap.map { _ in ()})
        ).bind { [weak self] _ in
            let offsetX = self?.scrollView.contentOffset.x ?? 0.0
            self?.scrollView.setContentOffset(CGPoint(x: offsetX + ScreenUtil.width, y: 0), animated: true)
        }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.dismiss }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.coordinator.pop()
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.cameraSelected }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.coordinator.camera()
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.albumSelected }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.coordinator.imagePicker()
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isAdding }
            .filter { $0 == false }
            .bind { [weak self] _ in
                self?.indicatorView.stopAnimating()
                self?.coordinator.pop()
            }.disposed(by: disposeBag)
        
        bindAddNameImageReactor(reactor: reactor)
        bindRemainDayReactor(reactor: reactor)
    }
}

extension AddItemViewController {
    private func bindAddNameImageReactor(reactor: AddItemReactor) {
        addNameAndImageView.reactor = reactor.subReactors.addNameAndIamgeReactor
        
        addNameAndImageView.imageBtn.rx.tap
            .map { Reactor.Action.addingImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addNameAndImageView.nameTextField.searchTextField.rx.text
            .compactMap { $0 }
            .map { Reactor.Action.foodName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.food.itemImage }
            .map { AddNameAndImageReactor.Action.addedImage($0) }
            .bind(to: reactor.subReactors.addNameAndIamgeReactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindRemainDayReactor(reactor: AddItemReactor) {
        remainDayView.reactor = reactor.subReactors.remainDayReactor
        
        remainDayView.nextBtn.rx.tap
            .map { [weak self] _ in Int(self?.remainDayView.sliderView.value ?? 0.0) }
            .map { Reactor.Action.remainDay($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        remainDayView.notSureBtn.rx.tap
            .map { Reactor.Action.remainDay(10000) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
