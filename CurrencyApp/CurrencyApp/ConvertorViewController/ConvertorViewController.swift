//
//  ConvertorViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

class ConvertorViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = ConvertorViewModel
    var viewModel: ConvertorViewModel!
    var alertPresenter: AlertViewPresenterType = AlertViewPresenter()
    
    @IBOutlet weak var convertButton: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        setupUI()
        setupEvent()
        fetchExchangeRates()
    }
}
extension ConvertorViewController {
    private func setupUI() {
        self.title = viewModel.title
        convertButton.rx.tap
            .bind(to: viewModel.convertButtonClicked)
            .disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewModel.events
            .flatMap { [weak self] event -> Observable<AlertModelEvent> in
            guard let self = self else { return Observable.empty() }
            switch event {
            case .showConvertAlert:
                let cancelButton = AlertModel(title: "Cancel", style: .cancel)
                let convertButton = AlertModel(title: "Convert", style: .default)
                
                return self.alertPresenter.present(title: "Alert",
                                                 message: "Are you sure you want to convert?",
                                                 actions: [cancelButton,
                                                           convertButton],
                                                 viewController: self)
            case .showErrorAlert(let message):
                let cancelButton = AlertModel(title: "Cancel", style: .cancel)
                return self.alertPresenter.present(title: "Error",
                                                   message: message,
                                                   actions: [cancelButton],
                                                   viewController: self)
            }
        }
        .filter({ $0 == .alertButtonTapped(buttonIndex: 1)})
        .map { _ in ()}
        .bind(to: viewModel.convertConfirmed)
        .disposed(by: disposeBag)
    }
    
    private func fetchExchangeRates() {
        viewModel.latestRateRequest.onNext(())
    }
}
