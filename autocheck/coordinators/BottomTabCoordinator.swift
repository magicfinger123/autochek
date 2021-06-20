//
//  BottomTabCoordinator.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation
import UIKit
enum TabBarPage {
    case home
    case transaction
    case payments
    case invoicing
    case analytics

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .transaction
        case 2:
            self = .payments
        case 3:
            self = .invoicing
        case 4:
            self = .analytics
        default:
            return nil
        }
    }
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .transaction:
            return "Recharge"
        case .payments:
            return "Payment"
        case .invoicing:
            return "History"
        case .analytics:
            return "Profile"
        }
    }
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .transaction:
            return 1
        case .payments:
            return 2
        case .invoicing:
            return 3
        case .analytics:
            return 4
        }
    }
}

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    

}

protocol TabSceneProtocol{
    func goToCardDetails(carId: String)
}
class TabCoordinator: NSObject, Coordinator, TabSceneProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: MainTabController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController =  MainTabController.instantiate()
    }

    func start() {
        let pages: [TabBarPage] = [.home, .transaction, .payments, .invoicing, .analytics]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
    
    func goToCardDetails(carId: String){
        let vc = CarDetailsViewController.instantiate()
        vc.carId = carId
        let vm = HomeVM()
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
        
    }
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: nil,
                                                     tag: page.pageOrderNumber())
        switch page {
        case .home:
            let homeVc = HomeViewController.instantiate()
            let vm = HomeVM()
            homeVc.viewModel = vm
            vm.coordinatorProtocol = self
            navController.setNavigationBarHidden(true, animated: true)
            navController.pushViewController(homeVc, animated: true)
        default:
            let dummyVc = DummyViewController.instantiate()
            navController.setNavigationBarHidden(true, animated: true)
            navController.pushViewController(dummyVc, animated: true)
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
