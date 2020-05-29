//
//  MainViewCoordinator.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class MainViewCoordinator {
    var navigationController: UINavigationController!
    let viewModelCoordinator = MainViewModelCoordinator()
    
    init() {
        startApplication()
    }
}

extension MainViewCoordinator {
    private func startApplication() {
        let viewModel = viewModelCoordinator.createStartUpViewModel()
        let viewController = UIViewController.make(viewController: ConvertorViewController.self)
        self.navigationController = UINavigationController.init(rootViewController: viewController)
    }
}
