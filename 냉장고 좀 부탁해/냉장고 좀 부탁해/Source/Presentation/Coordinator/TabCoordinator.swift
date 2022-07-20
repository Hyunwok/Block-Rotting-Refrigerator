//
//  TabCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

enum TabBarPage {
    case refrigerator
    case recipe
    case setting
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .refrigerator
        case 1:
            self = .recipe
        case 2:
            self = .setting
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .refrigerator:
            return "refrigerator"
        case .recipe:
            return "recipe"
        case .setting:
            return "Go"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .refrigerator:
            return 0
        case .recipe:
            return 1
        case .setting:
            return 2
        }
    }
    
    func imageNameForPage() -> String {
        switch self {
        case .refrigerator:
<<<<<<< tempMain
<<<<<<< tempMain
            return "tray.2"
        case .recipe:
            return "fork.knife"
        case .setting:
            return "gearshape"
=======
            return ""
=======
            return "tray.2"
>>>>>>> asdasd
        case .recipe:
            return "fork.knife"
        case .setting:
<<<<<<< tempMain
            return ""
>>>>>>> [add] Complete Coordinator Setting
=======
            return "gearshape"
>>>>>>> asdasd
        }
    }
    
    func coordinator() -> Coordinator {
        switch self {
        case .refrigerator:
            return RefrigeratorCoordinator()
        case .recipe:
            return RecipeCoordinator()
        case .setting:
            return SettingCoordinator()
        }
    }
}

class TabCoordinator: NSObject, Coordinator {
    var rootViewController: UIViewController {
        return nav
    }
    
    var tabBarController: UITabBarController = {
        let tab = UITabBarController()
        tab.view.backgroundColor = .systemBackground
        tab.tabBar.isTranslucent = false
        
        tab.selectedIndex = 0
        
        return tab
    }()
    
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let pages: [TabBarPage] = [.refrigerator, .recipe, .setting]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        let _ = pages.map { childCoordinator.append($0.coordinator()) }
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.refrigerator.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        nav.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let rootVC = page.coordinator().rootViewController
        
        let navController = UINavigationController(rootViewController: rootVC)
<<<<<<< tempMain
<<<<<<< tempMain
=======
>>>>>>> asdasd
        navController.setNavigationBarHidden(true, animated: false)

        let image = UIImage(named: page.imageNameForPage()) == nil ? UIImage(systemName: page.imageNameForPage()) : UIImage(named: page.imageNameForPage())
        navController.tabBarItem = UITabBarItem.init(title: nil,
                                                     image: image,
<<<<<<< tempMain
=======
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: nil,
>>>>>>> [add] Complete Coordinator Setting
=======
>>>>>>> asdasd
                                                     tag: page.pageOrderNumber())
        
        return navController
    }
}

extension TabCoordinator: UITabBarControllerDelegate {}
