//
//  Blocking_Rotting_Test.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/09/15.
//

import XCTest
import ReactorKit
import UIKit
@testable import 냉장고_좀_부탁해

class Blocking_Rotting_Test: XCTestCase {
    let mockRepo = MockRepo()
    let mockCoordi = MockRefrigeratorCoordinator()
    let mockAlertService = MockAlertService()
    
    lazy var reactor = RefrigeratorReactor(mockAlertService, mockRepo)
    lazy var vc = RefrigeratorViewController(reactor, mockCoordi)
    
    func test_패치를_잘_받아오는지() {
        
        // given
        let reactor = RefrigeratorReactor(mockAlertService, mockRepo)
        let vc = RefrigeratorViewController(reactor, mockCoordi)
        
        // when
        vc.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(reactor.fetchedFoods.count,3)
    }
    
    func test_패치갯수가_0일때() {
        
        // given
        mockRepo.isFail = true
        
        // when
        vc.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(reactor.fetchedFoods.count, 0)
    }
    
    func test_패치후_순서를_잘받아오는지() {
        
        // when
        vc.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(reactor.fetchedFoods.first?.type, .cereals)
    }
    
    func test_알람체크_Frozen() {
        // when
        test_필터링시_섹션의_갯수와타입확인(.frozen)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 2)
    }
    
    func test_알람체크_coldTem() {
        
        // when
        test_필터링시_섹션의_갯수와타입확인(.coldTem)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 1)
    }
    
    func test_알람체크_roomTem() {
        
        // when
        test_필터링시_섹션의_갯수와타입확인(.roomTem)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 1)
    }
    
    func test_알람체크_많은날짜() {
        
        // when
        test_필터링시_섹션의_갯수와타입확인(.moreDay)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.first?.remainingDay, 10)
        
    }
    
    func test_알람체크_적은날짜() {
        
        // when
        test_필터링시_섹션의_갯수와타입확인(.lessDay)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.first?.remainingDay, 0)
    }
    
    private func test_필터링시_섹션의_갯수와타입확인(_ alertType: FoodSortAlertAction) {
        
        // given
        vc.loadViewIfNeeded()
        
        // when
        mockAlertService.selectAction = alertType
        reactor.action.onNext(.orderBy)
        
        // then
        if alertType != .cancel && reactor.currentState.isOrdered {
            XCTAssertEqual(reactor.currentState.currentFoods.first?.type, FoodType.none)
            XCTAssertEqual(reactor.currentState.currentFoods.count, 1)
        }
    }
    
    func test_알람체크_취소_isOrder가있을때() {
        
        // given
        vc.loadViewIfNeeded()
        
        // when
        reactor.action.onNext(.search("2"))
        mockAlertService.selectAction = FoodSortAlertAction.cancel
        reactor.action.onNext(.orderBy)
        
        // then
        XCTAssertEqual(reactor.filterFoods.first?.items.count, 1)
        XCTAssertEqual(reactor.currentState.currentFoods.first?.type, FoodType.none)
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 1)
    }
    
    func test_알람체크_취소_isOrder가없을때() {
        
        // when
        test_필터링시_섹션의_갯수와타입확인(.cancel)
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.count, 3)
        XCTAssertEqual(reactor.currentState.currentFoods.first?.type, .cereals)
    }
    
    func test_빈서칭검사() {
        
        // given
        vc.loadViewIfNeeded()
        
        // when
        reactor.action.onNext(.search(""))
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.count, 3)
        XCTAssertEqual(reactor.currentState.currentFoods.first?.type, .cereals)
    }
    
    func test_초성검사() {
        // given
        vc.loadViewIfNeeded()
        
        // when
        reactor.action.onNext(.search("ㅂㅈㄷ"))
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 0)
    }
    
    func test_검색결과있을때() {
        // given
        vc.loadViewIfNeeded()
        
        // when
        reactor.action.onNext(.search("test"))
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 4)
    }
    
    func test_검색결과없을때() {
        
        // given
        vc.loadViewIfNeeded()
        
        // when
        reactor.action.onNext(.search("없는이름"))
        
        // then
        XCTAssertEqual(reactor.currentState.currentFoods.first?.items.count, 0)
    }
}
