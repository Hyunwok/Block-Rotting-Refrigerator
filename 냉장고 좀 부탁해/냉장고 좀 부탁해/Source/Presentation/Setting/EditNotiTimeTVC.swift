//
//  EditNotiTimeTVC.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/09/30.
//

import UIKit

import SnapKit

final class EditNotiTimeTVC: UITableViewCell {
    static let id = "EditNotiTimeTVC"
    
    var contentLabelBottomMargin: Constraint!
    
    var showMore: Bool! {
        willSet {
            moreBtn.isSelected = newValue
            contentLabelBottomMargin.update(inset: newValue ? 190 : 12)
        }
    }
    
    let titleLbl = UILabel()
    let moreBtn = UIButton()
    let picker = UIPickerView()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setting()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        moreBtn.setTitle("\(UserDefaultStorage.shared.remainDay)일 ", for: .normal)
    }
    
    private func setting() {
        self.contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        titleLbl.text = "알림 시간 설정"
        moreBtn.setTitleColor(.black, for: .normal)
        moreBtn.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreBtn.setImage(UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate), for: .selected)
        moreBtn.tintColor = .black
        moreBtn.titleLabel?.font = .systemFont(ofSize: 15)
        moreBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14), forImageIn: .normal)
        moreBtn.setTitle("\(UserDefaultStorage.shared.remainDay)일 ", for: .normal)
        print(UserDefaultStorage.shared.remainDay)
        moreBtn.semanticContentAttribute = .forceRightToLeft
        moreBtn.isUserInteractionEnabled = false
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(UserDefaultStorage.shared.remainDay - 1, inComponent: 0, animated: false)
        
        self.addSubviews([titleLbl, moreBtn, picker])
    }
    
    private func layout() {
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            contentLabelBottomMargin = $0.bottom.equalToSuperview().inset(12).constraint
        }
        
        moreBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        picker.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(150)
        }
    }
}

extension EditNotiTimeTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row  + 1)일"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultStorage.shared.remainDay = row + 1
        moreBtn.setTitle("\(row + 1)일 ", for: .normal)
        moreBtn.setTitle("\(row + 1)일 ", for: .selected)
        moreBtn.setNeedsDisplay()
    }
}
