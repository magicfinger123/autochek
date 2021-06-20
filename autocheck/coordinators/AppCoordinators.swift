//
//  AppCoordinators.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation

import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
enum CoordinatorType {
    case app, login, tab
    case recharge, payment
}
protocol AppCoordinatorProtocol: Coordinator {
    func showHomePage()
    func showCarDetails()
}
final class AppCoordinator : AppCoordinatorProtocol{
    func showCarDetails() {
        //let navigationController = UINavigationController()
//        let appLaunchCordinator = ApplaunchCordinator.init(navigationController: navigationController)
//        appLaunchCordinator.finishDelegate = self
//        appLaunchCordinator.start()
//        childCordinators.append(appLaunchCordinator)
        
    }
    func  showHomePage() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }

    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    private(set)  var childCordinators: [Coordinator] = []
    func start() {
    showHomePage()
    }
}
extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()
            showHomePage()
        case .login, .payment:
            navigationController.viewControllers.removeAll()
            showCarDetails()
        default:
            break
        }
    }
}


