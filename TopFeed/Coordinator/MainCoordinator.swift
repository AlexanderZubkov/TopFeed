//
//  MainCoordinator.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

class MainCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
    private weak var navigationController: UINavigationController?

    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let navigationController = navigationController else { return }
        
        let mainControllerViewModel = MainViewControllerViewModel()
        let mainVC = MainViewController.instance()
        mainVC.viewModel = mainControllerViewModel

        navigationController.pushViewController(mainVC, animated: true)
    }
}
