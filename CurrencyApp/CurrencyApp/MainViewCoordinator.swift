//
//  MainViewCoordinator.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift

class MainViewCoordinator {
    var navigationController: UINavigationController!
    let viewModelCoordinator = MainViewModelCoordinator()
    
    private let disposeBag = DisposeBag()
    init() {
        setupNavigationAction()
        startApplication()
    }
}

extension MainViewCoordinator {
    private func startApplication() {
        let viewModel = self.viewModelCoordinator.createStartUpViewModel()
        let rootVc = getViewController(viewModel)
        self.navigationController = UINavigationController.init(rootViewController: rootVc)
    }
    
    private func setupNavigationAction() {
        viewModelCoordinator
            .navigationAction
            .subscribe(onNext: { event in
                switch event {
                case .push(let viewModel, let animated):
                    let vc = self.getViewController(viewModel)
                    self.navigationController
                        .pushViewController(vc, animated: animated)
                case .pop(let animated):
                   self.navigationController
                    .popViewController(animated: animated)
                default: break
                } })
            .disposed(by: disposeBag)
    }
    
    private func getViewController(_ viewModel: Any) -> UIViewController {
        switch viewModel {
        case let viewModel as ConvertorViewModel :
            let vc = UIViewController.make(viewController: ConvertorViewController.self)
            vc.viewModel = viewModel
            return vc

        case let viewModel as TransactionViewModel :
            let vc = UIViewController.make(viewController: TransactionViewController.self)
            vc.viewModel = viewModel
            return vc

        default: return UIViewController()
        }
    }
}
