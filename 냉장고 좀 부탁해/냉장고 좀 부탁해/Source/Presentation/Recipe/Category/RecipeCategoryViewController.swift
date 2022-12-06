//
//  RecipeViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

import SnapKit
import RxSwift
import ReactorKit

final class RecipeCategoryViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private var category = [Category]()
    private let coordinator: RecipeCoordinatorProtocol
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerClassCell(CategoryCell.self)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(_ reactor: RecipeCategoryReactor, _ coordinator: RecipeCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        //        Observable.of(()).map { Reactor.Action.load }.bind(to: reactor.action).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    private func setting() {
        self.title = "카테고리"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubviews([collectionView])
    }
    
    private func layout() {
        self.collectionView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)//.offset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func bind(reactor: RecipeCategoryReactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.load }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .bind {
                self.coordinator.moveToList(MealType.allCases[$0.item])
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { category -> [Category] in
                self.category = category.categories
                return category.categories
            }.bind(to: self.collectionView.rx.items(cellIdentifier: CategoryCell.id, cellType: CategoryCell.self)) { index, _, cell in
                cell.setData(index)
            }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RecipeCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ScreenUtil.width / 2) - 20
        let height = (collectionView.visibleSize.height / CGFloat(self.category.count / 2)) - 10
        
        if height < 60 {
            return CGSize(width: width, height: 60)
        } else {
            return CGSize(width: width, height: height)
        }
    }
}
