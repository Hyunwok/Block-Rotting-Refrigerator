//
//  Foods.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/16.
//

import Foundation

import RealmSwift
import RxDataSources

struct FoodsSecs {
    var items: [Item]
}

extension FoodsSecs: SectionModelType {
    typealias Item = FoodSection
    
    init(original: FoodsSecs, items: [Item]) {
        self = original
        self.items = items
    }
}


struct Foods {
    var items: [Item]
}

extension Foods: SectionModelType {
    typealias Item = FoodItem
    
    init(original: Foods, items: [Item]) {
        self = original
        self.items = items
    }
}
