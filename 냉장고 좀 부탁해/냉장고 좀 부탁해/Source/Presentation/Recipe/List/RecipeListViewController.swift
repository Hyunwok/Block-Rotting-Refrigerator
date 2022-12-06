//
//  RecipeListViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/30.
//

import UIKit

import ReactorKit
import RxViewController

final class RecipeListViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    var category: String!
    private let coordinator: RecipeCoordinatorProtocol
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.registerClassCell(MealCollectionViewCell.self)
        view.backgroundColor = .white
        return view
    }()
    
    init(_ reactor: RecipeListReactor, _ coordinator: RecipeCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RecipeListViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    private func setting() {
        self.title = "레시피"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemYellow
        
        self.view.addSubview(collectionView)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.layoutMarginsGuide)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func bind(reactor: RecipeListReactor) {
        self.rx.viewDidLoad
            .map { [weak self] _ in self?.category}
            .compactMap{ $0 }
            .map { Reactor.Action.load(category: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(FoodDetailResponseDTO.self)
            .bind { [weak self] model in
                self?.coordinator.moveToDetail(model)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().skip(1).distinctUntilChanged { $0.isLoaded != $1.isLoaded }
            .map { $0.meals }
            .bind(to: collectionView.rx.items(cellIdentifier: MealCollectionViewCell.id, cellType: MealCollectionViewCell.self)) { _, data, cell in
                cell.setData(data)
            }.disposed(by: disposeBag)
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RecipeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenUtil.width - 20, height: collectionView.visibleSize.height / 2.5)
    }
}
