//
//  EditViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/23.
//

import UIKit

import ReactorKit
import SnapKit
import RxViewController
import PhotosUI

final class EditViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    var food: FoodItem! {
        willSet {
            self.compareFood = newValue
            self.originalFood = newValue
        }
    }
    private var compareFood: FoodItem?
    private var originalFood: FoodItem?
    private var image: UIImage?
    private var nameLbl = UILabel()
    private var remainDayLbl = UILabel()
    private var typeLbl = UILabel()
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)
        return view
    }()
    
    private var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.rgb(72, 162, 214, 1), for: .normal)
        btn.setTitleColor(.red, for: .selected)
        return btn
    }()
    
    private var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .red
        return btn
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "재료 정보 수정"
        lbl.font = .systemFont(ofSize: 17, weight: .bold)
        return lbl
    }()
    
    private var imageView: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        return btn
    }()
    
    private var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var nameInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "재료 이름"
        return lbl
    }()
    
    private var remainDayInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "남은 날짜"
        return lbl
    }()
    
    private var typeInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "보관 종류"
        lbl.textAlignment = .left
        return lbl
    }()
    
    private var quantityInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "개수"
        return lbl
    }()
    
    private var quantitySubInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "개수를 0으로 수정 시에는 재료가 사라집니다."
        lbl.numberOfLines = 2
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()
    
    private var quantityPlusBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    private var quantityMinusBtn: UIButton  = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "minus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    private var quantityView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var quantityLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    private var editBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .rgb(72, 162, 214, 1)
        btn.setTitle("수정하기", for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    init(_ reactor: EditReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
         print("deinit EditViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    private func setting() {
        self.view.backgroundColor = .rgb(248, 248, 248, 1)
        
        var text = ""
        if food.remainingDay == 10000 {
            text = "알 수 없음"
        } else if food.remainingDay < 0 {
            text = "D-\(-1 * food.remainingDay)"
        } else if food.remainingDay < 1 {
            text = "D-Day"
        } else if food.remainingDay > 30 {
            text = "D-30"
        } else {
            text = "D-\(food.remainingDay)"
        }
        
        self.emptyImageView.isHidden = (food.itemImage != nil)
        self.imageView.setImage(food.itemImage, for: .normal)
        self.nameLbl.text = food.name
        self.quantityLbl.text = "\(food.number)"
        self.remainDayLbl.text = text
        self.typeLbl.text = food.itemPlace.place
        self.image = self.imageView.currentImage
    }
    
    private func layout() {
        let baseView = UIView(backgroundColor: .white)
        baseView.layer.cornerRadius = 12
        let editBtnBaseView = UIView(backgroundColor: .white)
        let seperateView1 = UIView(backgroundColor: .black)
        let seperateView2 = UIView(backgroundColor: .black)
        let seperateView3 = UIView(backgroundColor: .black)
        
        self.view.addSubviews([titleLbl, closeBtn, deleteBtn, scrollView, editBtnBaseView])
        scrollView.addSubviews([imageView, baseView])
        quantityView.addSubviews([quantityPlusBtn, quantityMinusBtn, quantityLbl])
        editBtnBaseView.addSubview(editBtn)
        baseView.addSubviews([nameInfoLbl, nameLbl, seperateView1, remainDayInfoLbl, remainDayLbl, seperateView2, typeInfoLbl, typeLbl, seperateView3, quantityInfoLbl, quantitySubInfoLbl, quantityView])
        imageView.addSubview(emptyImageView)
        
        titleLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(30)
        }
        
        closeBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.centerY.equalTo(titleLbl.snp.centerY)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(23)
            $0.top.equalTo(closeBtn.snp.top)
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.width.height.equalTo(30)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtil.width / 8)
            $0.height.equalTo(ScreenUtil.height / 4.5)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        baseView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(editBtnBaseView.snp.top).offset(-50)
        }
        
        nameInfoLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview().dividedBy(4)
            $0.width.equalTo(70)
            $0.leading.equalToSuperview().inset(15)
        }
        
        nameLbl.snp.makeConstraints {
            $0.centerY.equalTo(nameInfoLbl)
            $0.leading.equalTo(nameInfoLbl.snp.trailing).offset(30)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        seperateView1.snp.makeConstraints {
            $0.height.equalTo(0.1)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview().dividedBy(2)
        }
        
        remainDayInfoLbl.snp.makeConstraints {
            $0.top.equalTo(seperateView1.snp.bottom)
            $0.bottom.equalTo(seperateView2.snp.top)
            $0.width.equalTo(70)
            $0.leading.equalTo(nameInfoLbl)
        }
        
        remainDayLbl.snp.makeConstraints {
            $0.leading.equalTo(nameLbl.snp.leading)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(remainDayInfoLbl)
        }
        
        seperateView2.snp.makeConstraints {
            $0.height.equalTo(0.1)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        typeInfoLbl.snp.makeConstraints {
            $0.top.equalTo(seperateView2.snp.bottom)
            $0.bottom.equalTo(seperateView3.snp.top)
            $0.leading.equalTo(nameInfoLbl)
            $0.width.equalTo(70)
        }
        
        typeLbl.snp.makeConstraints {
            $0.leading.equalTo(nameLbl.snp.leading)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(typeInfoLbl)
        }
        
        seperateView3.snp.makeConstraints {
            $0.height.equalTo(0.1)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview().multipliedBy(1.5)
        }
        
        quantityInfoLbl.snp.makeConstraints {
            $0.top.equalTo(seperateView3.snp.bottom).offset(10)
            $0.leading.equalTo(nameInfoLbl)
            $0.height.equalTo(22)
        }
        
        quantitySubInfoLbl.snp.makeConstraints {
            $0.top.equalTo(quantityInfoLbl.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(nameInfoLbl)
            $0.trailing.equalTo(quantityView.snp.leading).offset(-12)
        }
        
        quantityPlusBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
            $0.width.equalTo(30)
        }
        
        quantityMinusBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalTo(30)
        }
        
        quantityLbl.snp.makeConstraints {
            $0.leading.equalTo(quantityMinusBtn.snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(40)
            $0.trailing.equalTo(quantityPlusBtn.snp.leading)
        }
        
        quantityView.snp.makeConstraints {
            $0.height.equalTo(40).priority(.required)
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview().multipliedBy(1.75)
        }
        
        editBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(50)
        }
        
        editBtnBaseView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    func bind(reactor: EditReactor) {
        imageView.rx.tap
            .bind {
                let vc: PHPickerViewController = AppDIContainer.shared.resolve(registrationName: "OneImage")
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                self.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        Observable.merge(quantityMinusBtn.rx.tap.map { -1 }, quantityPlusBtn.rx.tap.map { 1 })
            .bind { [weak self] in
                let currentCnt = Int(self?.quantityLbl.text ?? "1")! + $0
                self?.quantityLbl.text = currentCnt <= 0 && $0 == -1 ? "0" : String(currentCnt)
                self?.compareFood?.number = currentCnt
            }.disposed(by: disposeBag)
        
        closeBtn.rx.tap
            .map { Reactor.Action.close(self.food.number != self.compareFood?.number) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editBtn.rx.tap
            .bind { [weak self] _ in
                // 이미지는 변하거나 삭제됨
                let bool = self?.imageView.currentImage == self?.image && self?.originalFood?.number == self?.compareFood?.number
                reactor.action.onNext(.edit((self?.compareFood, bool)))
            }.disposed(by: disposeBag)
        
        deleteBtn.rx.tap
            .map { [weak self] _ in self?.food }
            .compactMap { $0 }
            .map { Reactor.Action.delete($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.dismiss }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}

extension EditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let useImage = image as? UIImage else { return }
                    self.imageView.setImage(useImage, for: .normal)
                    self.imageView.layer.cornerRadius = 12
                    self.imageView.clipsToBounds = true
                    self.emptyImageView.isHidden = true
                    self.compareFood?.itemImage = useImage
                }
            }
        }
    }
}
