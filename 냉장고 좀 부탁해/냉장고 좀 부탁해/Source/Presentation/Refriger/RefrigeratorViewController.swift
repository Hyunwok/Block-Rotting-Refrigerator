//
//  RefrigeratorViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

import ReactorKit
import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

final class RefrigeratorViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    var cnt: Int!
    var foods: [FoodSection] = []
    private let coordinator: RefrigeratorCoordinatorProtocol
    private var titleLbl = UILabel()
    private var searchBar = SearchView()
    public var filterBtn = UIButton()
    
    private let topView = UIView()
    private let tabView = UIView()
    private let noneItemImageView = UIImageView()
    private let noneItemLbl = UILabel()
    private var tabCollectionTopConstraint: Constraint?
    private var topViewTopConstraint: Constraint?
    private var headerArr: [CGFloat] = [0]
    private var selectedIndex = 0
    
    private let addBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .addBtnColor
        btn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 23, bottom: 0, right: 23)
        layout.scrollDirection = .horizontal
//        layout.sectionHeadersPinToVisibleBounds = true
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerClassCell(TabCVC.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 10, bottom: 0, right:10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: ScreenUtil.width, height: 50)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.registerClassCell(ItemCVC.self)
        collectionView.registerReusableView(SectionHeaderCRV.self)
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: - Life Cycle
    init(_ reactor: RefrigeratorReactor, _ coor: RefrigeratorCoordinatorProtocol) {
        self.coordinator = coor
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
    
    // MARK: - Layout
    private func setting() {
        titleLbl.text = "냉장고 현황"
        titleLbl.font = .systemFont(ofSize: 30, weight: .heavy)
        searchBar.placeholder = "검색"
        searchBar.cornerRadius = 15
        searchBar.backgroundColor = .orange.withAlphaComponent(0.7)
        filterBtn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterBtn.tintColor = .label
        noneItemImageView.contentMode = .scaleAspectFit
        noneItemImageView.image = UIImage(named: "noneItem")!
        noneItemImageView.isHidden = true
        noneItemLbl.isHidden = true
        noneItemLbl.text = "재료가 없습니다.\n추가해주세요."
        noneItemLbl.textAlignment = .center
        noneItemLbl.numberOfLines = 0
        noneItemLbl.font = .systemFont(ofSize: 20, weight: .heavy)
    }
    
    private func layout() {
        self.view.addSubviews([itemCollectionView, noneItemImageView, noneItemLbl, addBtn, topView])
        topView.addSubviews([titleLbl, tabView])
        tabView.addSubviews([searchBar, filterBtn, tabCollectionView])
        
        topView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            self.topViewTopConstraint = $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20).constraint
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(23)
        }
        
        tabView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLbl)
        }
        
        filterBtn.snp.makeConstraints {
            $0.leading.equalTo(searchBar.snp.trailing).offset(4)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(50)
        }
        
        filterBtn.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(13)
        }
        
        tabCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            self.tabCollectionTopConstraint = $0.height.equalTo(60).constraint
        }
        
        itemCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        noneItemImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(ScreenUtil.width / 2)
        }
        
        noneItemLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(noneItemImageView.snp.bottom).offset(50)
        }
        
        addBtn.snp.makeConstraints {
            $0.height.width.equalTo(50)
            $0.bottom.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Bind
    func bind(reactor: RefrigeratorReactor) {
        Observable.merge(self.rx.viewDidLoad.map { _ in () },
                         self.rx.viewWillAppear.map { _ in () }.skip(1))
        .map { Reactor.Action.load }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.orderBy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        itemCollectionView.rx.modelSelected(FoodSection.Item.self)
            .bind { [weak self] item in
                self?.coordinator.selectedItem(item)
            }.disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.text
            .distinctUntilChanged()
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addBtn.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.coordinator.addItem()
            }.disposed(by: disposeBag)
        
        tabCollectionView.rx.itemSelected
            .bind { [weak self] idx in
                let y = self?.headerArr[safe: idx.row] ?? 0
                self?.itemCollectionView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
            }.disposed(by: disposeBag)
        
        itemCollectionView.rx.contentOffset
            .skip(1)
            .bind { offset in
                self.titleLbl.alpha = (50 - offset.y) / 42
                if self.cnt > 2 {
                    if offset.y <= 0 {
                        self.topViewTopConstraint?.update(offset: 40)
                    } else {
                        self.topViewTopConstraint?.update(offset: max(40-offset.y, -40))
                    }
                }
                
                if !(self.foods.first?.items.isEmpty ?? true) && !self.headerArr.isEmpty {
                    let float = self.headerArr.firstIndex { float in
                        offset.y <= float
                    } ?? self.headerArr.endIndex - 1
                    
                    let index = self.headerArr.distance(to: float)
                    
                    self.tabCollectionView.deselectItem(at: IndexPath(item: self.selectedIndex, section: 0),
                                                        animated: false)
                    
                    let realIndex = index - 1 < 0 ? 0 : index - 1
                    self.tabCollectionView.selectItem(at: IndexPath(item: realIndex, section: 0),
                                                      animated: false, scrollPosition: .centeredHorizontally)
                    
                    self.selectedIndex = index
                }
                
            }.disposed(by: disposeBag)
        
        reactor.state.map(\.totalCount)
            .distinctUntilChanged()
            .bind { [weak self] in
                self?.cnt = $0
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map(\.isHiddenSection)
            .bind { [weak self] state in
                self?.tabCollectionTopConstraint?.update(offset: state ? 0 : 60)
            }.disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<FoodSection> { datasource, collectionView, indexPath, foods in
            let cell = collectionView.dequeueReusableCell(for: indexPath, with: ItemCVC.self)
            cell.setting(foods)
            return cell
        } configureSupplementaryView: { dataSource, collectionView, _, indexPath in
            let header = collectionView.dequeueReusableView(SectionHeaderCRV.self, for: indexPath)
            header.setText(dataSource.sectionModels[indexPath.section].type.description)
            return header
        }
        
        reactor.state.asObservable().map(\.currentFoods)
            .map { [weak self] foods -> [FoodSection] in
                self?.foods = foods
                self?.tabView.isHidden = foods.isEmpty
                self?.itemCollectionView.isHidden = foods.isEmpty
                self?.noneItemImageView.isHidden = !foods.isEmpty
                self?.noneItemLbl.isHidden = !foods.isEmpty
                return foods.sorted { $0.type.rawValue < $1.type.rawValue } // foods를 정렬해서 주는지 체크
            }.skip(1).bind(to: tabCollectionView.rx.items(cellIdentifier: TabCVC.cellID, cellType: TabCVC.self)) { _, food, cell in
                cell.setData(food.type.description)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map(\.currentFoods)
            .skip(1)
            .bind(to: itemCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.merge(self.rx.viewDidAppear.map { _ in ()}, tabCollectionView.rx.didEndDisplayingCell.map { _ in ()})
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .delay(.microseconds(750), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                if !(self?.foods.isEmpty ?? true) {
                    self?.itemCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    self?.tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
                }
            }.disposed(by: disposeBag)
        
        self.itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tabCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RefrigeratorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 && indexPath.section != 0 {
            let itemsCnt = Double(self.foods[safe: indexPath.section - 1]?.items.count ?? 1)
            let sectionCnt = ceil(itemsCnt/2.0)
            let height = sectionCnt * (ScreenUtil.width / 2 + 37) + headerArr[indexPath.section - 1] + 50
            
            if !headerArr.contains(height) {
                headerArr.append(height)
            }
            
            headerArr.sort()
        }
        
        if collectionView.isEqual(tabCollectionView) {
            let size = self.foods[indexPath.row].type.description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)])
            return CGSize(width: size.width + 20, height: 60)
        } else {
            return CGSize(width: (ScreenUtil.width / 2) - 20, height: (ScreenUtil.width / 2) + 37)
        }
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
