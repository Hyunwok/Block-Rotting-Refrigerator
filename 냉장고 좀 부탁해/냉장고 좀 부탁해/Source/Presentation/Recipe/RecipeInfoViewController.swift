//
//  RecipeInfoViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/09/02.
//

import UIKit

import ReactorKit
import SnapKit
import RxSwift

final class RecipeInfoViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    var id: String!
    var name: String!
    var url: String?
    
    private let coor: RecipeCoordinatorProtocol
    
    private let scrollView = UIScrollView()
    private let baseView = UIView()
    private let imageView = UIImageView()
    private let ingredientVerticalStackView = UIStackView()
    private let youtubeBtn = UIButton()
    private let ingrementInfoLbl = UILabel()
    private let methodInfoLbl = UILabel()
    private let methodStackView = UIStackView()
    
    init(_ reactor: RecipeInfoReactor, _ coor: RecipeCoordinatorProtocol) {
        self.coor = coor
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RecipeInfoViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    
    private func setting() {
        self.view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        self.title = name
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        youtubeBtn.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        youtubeBtn.tintColor = .white
        youtubeBtn.layer.cornerRadius = 25
        youtubeBtn.imageView?.contentMode = .scaleAspectFit
        youtubeBtn.isHidden = true
        youtubeBtn.backgroundColor = .red
        
        ingredientVerticalStackView.axis = .vertical
        ingredientVerticalStackView.spacing = 2
        
        ingrementInfoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        ingrementInfoLbl.text = "필요한 재료들"
        
        methodInfoLbl.font = .systemFont(ofSize: 20, weight: .heavy)
        methodInfoLbl.text = "방법"
        
        methodStackView.axis = .vertical
        methodStackView.spacing = 6
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(baseView)
        self.baseView.addSubviews([imageView, ingrementInfoLbl, ingredientVerticalStackView, methodInfoLbl, methodStackView, youtubeBtn])
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        baseView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtil.height / 3.5).priority(.required)
        }
        
        youtubeBtn.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.bottom).offset(-12)
            $0.trailing.equalTo(imageView.snp.trailing).offset(-12)
            $0.width.height.equalTo(50)
        }
        
        ingrementInfoLbl.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(30)
        }
        
        ingredientVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(ingrementInfoLbl.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(23)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        methodInfoLbl.snp.makeConstraints {
            $0.top.equalTo(ingredientVerticalStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(30)
        }
        
        methodStackView.snp.makeConstraints {
            $0.top.equalTo(methodInfoLbl.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(23)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(0)
        }
    }
    
    func bind(reactor: RecipeInfoReactor) {
        self.rx.viewDidLoad
            .map { [weak self] _ in self?.id }
            .compactMap { $0 }
            .map { Reactor.Action.load(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.youtubeBtn.rx.tap
            .bind { [weak self] _ in
                self?.coor.youtube(self?.url)
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isHiddenYoutube }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] bool in
                self?.youtubeBtn.isHidden = bool
            }.disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.data.first }
            .observe(on: MainScheduler.instance)
            .filter { $0?.strMeasure1 != nil && $0?.strMeasure1 != "" }
            .bind { [weak self] data in
                if let urlString = data?.strMealThumb,
                   let url = URL(string: urlString),
                   let imageData = try? Data(contentsOf: url),
                   let image = UIImage(data: imageData, scale: 0.8) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
                
                self?.url = data?.strYoutube
                
                if data?.strMeasure1 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure1, data?.strIngredient1)
                }
                if data?.strMeasure2 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure2, data?.strIngredient2)
                }
                if data?.strMeasure3 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure3, data?.strIngredient3)
                }
                if data?.strMeasure4 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure4, data?.strIngredient4)
                }
                if data?.strMeasure5 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure5, data?.strIngredient5)
                }
                if data?.strMeasure6 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure6, data?.strIngredient6)
                }
                if data?.strMeasure7 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure7, data?.strIngredient7)
                }
                if data?.strMeasure8 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure8, data?.strIngredient8)
                }
                if data?.strMeasure9 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure9, data?.strIngredient9)
                }
                if data?.strMeasure10 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure10, data?.strIngredient10)
                }
                if data?.strMeasure11 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure11, data?.strIngredient11)
                }
                if data?.strMeasure12 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure12, data?.strIngredient12)
                }
                if data?.strMeasure13 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure13, data?.strIngredient13)
                }
                if data?.strMeasure14 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure14, data?.strIngredient14)
                }
                if data?.strMeasure15 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure15, data?.strIngredient15)
                }
                if data?.strMeasure16 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure16, data?.strIngredient16)
                }
                if data?.strMeasure17 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure17, data?.strIngredient17)
                }
                if data?.strMeasure18 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure18, data?.strIngredient18)
                }
                if data?.strMeasure19 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure19, data?.strIngredient19)
                }
                if data?.strMeasure20 != "" {
                    self?.addIngredientVerticalStackView(data?.strMeasure20, data?.strIngredient20)
                }
                
                self?.addMethodStackView(data?.strInstructions)
            }.disposed(by: disposeBag)
    }
    
    private func addIngredientVerticalStackView(_ measure: String?, _ ingredient: String?) {
        if !(measure != "" && measure != " " && !(measure?.isEmpty ?? true) && measure != nil) { return }
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        let measureLbl = UILabel()
        let ingredientLbl = UILabel()
        measureLbl.font = .systemFont(ofSize: 14)
        ingredientLbl.font = .systemFont(ofSize: 17, weight: .heavy)
        measureLbl.textAlignment = .right
        measureLbl.text = measure
        ingredientLbl.text = ingredient
        horizontalStackView.addArrangedSubviews([ingredientLbl, measureLbl])
        
        self.ingredientVerticalStackView.addArrangedSubview(horizontalStackView)
        
        ingredientVerticalStackView.snp.updateConstraints {
            $0.height.equalTo(ingredientVerticalStackView.subviews.count * 20 + (ingredientVerticalStackView.subviews.count - 1) * 2)
        }
    }
    
    private func addMethodStackView(_ methods: String?) {
        guard let text = methods else { return }
        let methodArr = text.components(separatedBy: "\n")
        var height: CGFloat = 0.0
        var index = 0
        for idx in 0..<methodArr.count  {
            let horizontalStackView = UIStackView()
            let cntLbl = UILabel()
            let methodLbl = UILabel()
            
            methodLbl.text = methodArr[idx].components(separatedBy: "\r").first
            
            if Int(methodLbl.text ?? "") != nil || methodLbl.text == "" || methodLbl.text == " " { continue }
            index += 1
            
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 5
            
            cntLbl.font = .systemFont(ofSize: 17, weight: .heavy)
            cntLbl.textAlignment = .center
            cntLbl.text =  "\(index)."
            
            methodLbl.font = .systemFont(ofSize: 15, weight: .regular)
            methodLbl.numberOfLines = 0
            methodLbl.sizeToFit()
            
            let labelTextSize = methodArr[idx].boundingRect(
                with: CGSize(width: ScreenUtil.width - 81, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)],
                context: nil
            )
            
            cntLbl.snp.makeConstraints {
                $0.width.equalTo(30)
            }
            
            methodLbl.snp.makeConstraints {
                $0.height.equalTo(labelTextSize.height + 1)
            }
            
            height += labelTextSize.height + 1
            horizontalStackView.addArrangedSubviews([cntLbl, methodLbl])
            self.methodStackView.addArrangedSubview(horizontalStackView)
        }
        
        height += CGFloat(4 * (methodArr.count - 1))
        methodStackView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
