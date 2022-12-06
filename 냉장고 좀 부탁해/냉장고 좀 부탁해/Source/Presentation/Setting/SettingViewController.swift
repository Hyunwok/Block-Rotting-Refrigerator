//
//  SettingViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

class SettingViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var showMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    private func setting() {
        self.title = "설정"
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.registerClassCell(EditNotiTimeTVC.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.isMultipleTouchEnabled = true
//        tableView.isUserInteractionEnabled = false
        
        self.view.addSubviews([tableView])
    }
    
    private func layout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: EditNotiTimeTVC.self)
        showMore.toggle()
        cell.showMore = showMore
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? EditNotiTimeTVC {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
