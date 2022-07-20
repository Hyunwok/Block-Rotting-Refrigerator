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

final class RefrigeratorViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var titleLbl = UILabel()
    private var searchBar = SearchView()
    private var filterBtn = UIButton()
    private var addBtn = UIButton()
    
    var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.registerClassCell(TabCVC.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:5, left: 5, bottom: 5, right:5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: ScreenUtil.width, height: 50)
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (ScreenUtil.width - 45) / 2, height: ScreenUtil.height / 3.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.registerClassCell(ItemCVC.self)
        collectionView.registerReusableView(SectionHeaderCRV.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    // MARK: - Layout
    private func setting() {
        addBtn.backgroundColor = .red
        titleLbl.text = "냉장고 현황"
        titleLbl.font = .systemFont(ofSize: 24, weight: .heavy)
        searchBar.placeholder = "검색"
        searchBar.cornerRadius = 15
        searchBar.searchTextField.delegate = self
        filterBtn.setImage(UIImage(named: "filter"), for: .normal)
        tabCollectionView.backgroundColor = .red
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        
        self.view.addSubviews([titleLbl, searchBar, filterBtn, tabCollectionView, itemCollectionView, addBtn])
    }
    
    private func layout() {
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().inset(23)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(titleLbl.snp.bottom).offset(23)
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
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.height.equalTo(60)
        }
        
        itemCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(12.5)
            $0.bottom.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints {
            $0.height.width.equalTo(50)
            $0.bottom.trailing.equalToSuperview().inset(20)
        }
    }
}

extension RefrigeratorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(tabCollectionView) {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(tabCollectionView) {
            let cell = collectionView.dequeueReusableCell(for: indexPath, with: TabCVC.self)
            cell.setData(String(indexPath.row))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, with: ItemCVC.self)
            cell.setting(FoodItem(itemPlace: .coldTem, name: "양파", remainingDay: 2, number: 3, itemImage: nil))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableView(SectionHeaderCRV.self, for: indexPath)
        header.setText(String(indexPath.section))
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(CGSize(width: (ScreenUtil.width - 8) / 2, height: ScreenUtil.height / 3.5))
    }
}

extension RefrigeratorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.interactions
    }
}

extension RefrigeratorViewController: UITextFieldDelegate {}

