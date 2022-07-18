//
//  LaunchViewController.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

import SnapKit

class LaunchViewController: UIViewController {
    let lbl = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        animation()
        // Do any additional setup after loading the view.
    }
    
    func setting() {
        lbl.text = "AShdakjsdhjashdjasd"
        lbl.font = .systemFont(ofSize: 30, weight: .heavy)
        
        self.view.addSubview(lbl)
    }
    
    func animation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: {
            self.lbl.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [],
                           animations: {
                self.lbl.alpha = 0
            })
        }
    }

}
