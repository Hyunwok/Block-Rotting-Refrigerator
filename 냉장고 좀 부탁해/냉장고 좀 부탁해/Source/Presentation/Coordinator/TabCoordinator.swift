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
            return "Refrigerator"
        case .recipe:
            return "Recipe"
        case .setting:
            return "Setting"
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
            return "tray.2"
        case .recipe:
            if #available(iOS 15.0, *) {
                return "magazine"
            } else {
                return "newspaper"
            }
        case .setting:
            return "gearshape"
        }
    }
    
    func imageNameForSelectedPage() -> String {
        switch self {
        case .refrigerator:
            return "tray.2.fill"
        case .recipe:
            if #available(iOS 15.0, *) {
                return "magazine.fill"
            } else {
                return "newspaper.fill"
            }
        case .setting:
            return "gearshape.fill"
        }
    }
    
    func rootViewControllerForPage() -> UIViewController {
        switch self {
        case .refrigerator:
            return AppDIContainer.shared.resolve() as RefrigeratorViewController
        case .recipe:
            return AppDIContainer.shared.resolve() as RecipeCategoryViewController
        case .setting:
            return SettingViewController()
        }
    }
    
    func getCoordinator() -> Coordinator {
        switch self {
        case .refrigerator:
            return AppDIContainer.shared.resolve() as TabBarCoordinatorProtocol
        case .recipe:
            return RecipeCoordinator(UINavigationController())
        case .setting:
            return SettingCoordinator(UINavigationController())
        }
    }
}

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get }
}

class TabCoordinator: NSObject, TabBarCoordinatorProtocol {
    var tabBarController: UITabBarController = {
        let tab = UITabBarController()
        tab.view.backgroundColor = .systemBackground
        tab.tabBar.isTranslucent = false
        
        tab.selectedIndex = 0
        
        return tab
    }()
    
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let pages: [TabBarPage] = [.refrigerator, .recipe, .setting]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        let _ = pages.map { childCoordinator.append($0.getCoordinator()) }
        
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
        let nav: UINavigationController = AppDIContainer.shared.resolve(registrationName: page.pageTitleValue())
        nav.setViewControllers([page.rootViewControllerForPage()], animated: false)
        
        let image = UIImage(named: page.imageNameForPage()) == nil ? UIImage(systemName: page.imageNameForPage()) : UIImage(named: page.imageNameForPage())
        
        nav.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                           image: image,
                                           tag: page.pageOrderNumber())
        nav.tabBarItem.selectedImage = UIImage(systemName: page.imageNameForSelectedPage())!
        
        return nav
    }
}

extension TabCoordinator: UITabBarControllerDelegate {}
