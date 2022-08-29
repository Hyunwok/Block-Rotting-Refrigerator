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
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerClassCell(CategoryCell.self)
       return collectionView
    }()
    
    init(_ reactor: RecipeReactor) {
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
    
    private func setting() {
        self.title = "레시피"
        
        self.view.addSubviews([collectionView])
    }
    
    private func layout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: RecipeReactor) {
        self.rx.viewDidLoad
            .map { _ in () }
            .map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.categories }
            .bind(to: self.collectionView.rx.items(cellIdentifier: CategoryCell.id, cellType: CategoryCell.self)) { index, _, cell in
                cell.setData(index)
            }.disposed(by: disposeBag)
    }
}
