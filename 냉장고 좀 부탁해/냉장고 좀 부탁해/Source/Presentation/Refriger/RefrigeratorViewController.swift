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
    
    var foods: [FoodSection] = []
    private var titleLbl = UILabel()
    private var searchBar = SearchView()
    private var filterBtn = UIButton()
    private var addBtn = UIButton()
    private let topView = UIView()
    private let tabView = UIView()
    private let noneItemImageView = UIImageView()
    private let noneItemLbl = UILabel()
    private var tabCollectionTopConstraint: Constraint?
    private var topViewTopConstraint: Constraint?
    private var headerArr: [CGFloat] = [0]
    private var selectedIndex = 0
    private var isEmpty = true
    
    var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 23, bottom: 0, right: 23)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerClassCell(TabCVC.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
        //        collectionView.contentInset = UIEdgeInsets(top: 170, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView.registerClassCell(ItemCVC.self)
        collectionView.registerReusableView(SectionHeaderCRV.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    init(_ reactor: RefrigeratorReactor) {
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
        self.view.backgroundColor = .rgb(108, 175, 186, 1)
        addBtn.backgroundColor = .addBtnColor
        addBtn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        addBtn.tintColor = .white
        addBtn.layer.cornerRadius = 25
        titleLbl.text = "냉장고 현황"
        titleLbl.font = .systemFont(ofSize: 30, weight: .heavy)
        searchBar.placeholder = "검색"
        searchBar.cornerRadius = 15
        searchBar.backgroundColor = .rgb(36, 54, 60, 1)
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
        
        topView.backgroundColor = .rgb(108, 175, 186, 1)
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
            //            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
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
    
    func layout2() {
        self.view.addSubviews([titleLbl, tabCollectionView, itemCollectionView, noneItemImageView, noneItemLbl, addBtn])
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(23)
        }
        
        tabCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.height.equalTo(60)
        }
        
        itemCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom)
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
                         self.rx.viewDidAppear.map { _ in () }.skip(1))
        .map { Reactor.Action.load }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.orderBy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        itemCollectionView.rx.itemSelected
            .map {
                let food = self.foods[$0.section]
                let foodSec = FoodSection(id: food.id, type: food.type, items: [food.items[$0.item]])
                return Reactor.Action.itemSelect(foodSec)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.text
            .distinctUntilChanged()
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.addItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabCollectionView.rx.itemSelected
            .bind {
                let y = self.headerArr[safe: $0.row] ?? 0
                self.itemCollectionView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            }.disposed(by: disposeBag)
        
        itemCollectionView.rx.contentOffset
            .skip(1)
            .bind { offset in
                if !(self.foods.first?.items.isEmpty ?? true) && !self.headerArr.isEmpty {
                    let float = self.headerArr.firstIndex { float in
                        offset.y <= float
                    } ?? self.headerArr.endIndex - 1
                    let index = self.headerArr.distance(to: float)
                    self.tabCollectionView.deselectItem(at: IndexPath(item: self.selectedIndex, section: 0),
                                                        animated: false)
                    self.tabCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                      animated: false, scrollPosition: .centeredHorizontally)
                    
                    self.selectedIndex = index
                } else if !self.isEmpty {
                    self.tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                                      animated: false, scrollPosition: .centeredHorizontally)
                }
                
                self.titleLbl.alpha = (50 - offset.y) / 42
                if offset.y <= 0 {
                    self.topViewTopConstraint?.update(offset: 40)
                } else {
                    self.topViewTopConstraint?.update(offset: max(40-offset.y, -40))
                }
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.fetchedFood }
            .bind {
                self.isEmpty = $0.isEmpty
                self.foods = $0
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isHiddenSection }
            .bind {
                self.tabCollectionTopConstraint?.update(offset: $0 ? 0 : 60)
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
        
        reactor.state.asObservable().map { $0.fetchedFood }
            .map { food -> [FoodSection] in
                let isRealEmpty = self.foods.isEmpty
                self.tabView.isHidden = food.isEmpty && isRealEmpty
                self.itemCollectionView.isHidden = food.isEmpty && isRealEmpty
                self.noneItemImageView.isHidden = !(food.isEmpty && isRealEmpty)
                self.noneItemLbl.isHidden = !(food.isEmpty && isRealEmpty)
                return food.sorted { $0.type.rawValue < $1.type.rawValue }
            }.bind(to: tabCollectionView.rx.items(cellIdentifier: TabCVC.cellID, cellType: TabCVC.self)) { _, food, cell in
                cell.setData(food.type.description)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.currentFoods }
            .bind(to: itemCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tabCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RefrigeratorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 && indexPath.section != 0 {
            let row = CGFloat(ceil(Double(self.foods[safe: indexPath.section - 1]?.items.count ?? 1) / 2))
            let height = row * (ScreenUtil.height / 3.5) + headerArr[indexPath.section - 1] + 50
            if self.foods.endIndex - 1 == indexPath.section {
                
            }
            //            let row = CGFloat(ceil(Double(self.foods[safe: indexPath.section - 1]?.items.count ?? 1) / 2))
            //            let height = row * (ScreenUtil.height / 3.5) + headerArr[indexPath.section - 1] + 50
            
            if !headerArr.contains(height) {
                headerArr.append(height)
            }
            
            headerArr.sort()
            print(headerArr)
        }
        
        if collectionView.isEqual(tabCollectionView) {
            let size = self.foods[indexPath.section].type.description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)])
            return CGSize(width: size.width + 20, height: 60)
        } else {
            return CGSize(width: (ScreenUtil.width / 2) - 20, height: ScreenUtil.height / 3.5)
        }
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
