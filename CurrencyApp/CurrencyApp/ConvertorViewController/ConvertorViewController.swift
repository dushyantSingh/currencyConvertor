//
//  ConvertorViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class ConvertorViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = ConvertorViewModel
    var viewModel: ConvertorViewModel!
    var alertPresenter: AlertViewPresenterType = AlertViewPresenter()
    
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    @IBOutlet weak var fromCurrencyCodeTextField: UITextField!
    @IBOutlet weak var toCurrencyCodeTextField: UITextField!
    @IBOutlet weak var toCurrencyView: UIView!
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var fromPickerView = UIPickerView()
    var toPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        setupWallet()
        setupShowTransactionButton()
        setupCurrencyTextField()
        setupCurrencyCodeTextFields()
       
        setupFromPickerView()
        setupToPickerView()
        fetchExchangeRates()
    }
}
extension ConvertorViewController {
    private func setupUI() {
        self.title = viewModel.title
        
        self.fromCurrencyView.setCornerRadius(.large)
        self.toCurrencyView.setCornerRadius(.large)
        self.convertButton.setCornerRadius(.small)
        
        convertButton.rx.tap
            .bind(to: viewModel.convertButtonClicked)
            .disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {[weak self] _ in
                self?.view.endEditing(true) })
            .disposed(by: disposeBag)
    }
    
    private func setupWallet() {
        viewModel.walletBalance
            .bind(to: self.walletBalanceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupCurrencyTextField() {
        viewModel.fromCurrency.asObservable()
            .bind(to: self.fromCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.toCurrency.asObservable()
            .bind(to: self.toCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        fromCurrencyTextField.rx.text
            .orEmpty
            .bind(to: viewModel.fromCurrency)
            .disposed(by: disposeBag)
        
        toCurrencyTextField.rx.text
            .orEmpty
            .bind(to: viewModel.toCurrency)
            .disposed(by: disposeBag)
        
        toCurrencyTextField.rx
            .controlEvent([.editingDidBegin])
            .map { true }
            .bind(to: self.viewModel.skipCalculation)
            .disposed(by: disposeBag)
        
        toCurrencyTextField.rx
            .controlEvent([.editingDidEnd])
            .map { false }
            .bind(to: self.viewModel.skipCalculation)
            .disposed(by: disposeBag)
        
        toCurrencyCodeTextField.inputView = toPickerView
        fromCurrencyCodeTextField.inputView = fromPickerView
    }
    
    private func setupCurrencyCodeTextFields() {
        viewModel.fromCurrencyCode.asObservable()
            .bind(to: self.fromCurrencyCodeTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.toCurrencyCode.asObservable()
            .bind(to: self.toCurrencyCodeTextField.rx.text)
            .disposed(by: disposeBag)
        
        fromCurrencyCodeTextField.rx.text
            .orEmpty
            .bind(to: viewModel.fromCurrencyCode)
            .disposed(by: disposeBag)
        
        toCurrencyCodeTextField.rx.text
            .orEmpty
            .bind(to: viewModel.toCurrencyCode)
            .disposed(by: disposeBag)
    }

    private func setupEvent() {
        viewModel.events
            .flatMap { [weak self] event -> Observable<AlertModelEvent> in
                guard let self = self else { return Observable.empty() }
                switch event {
                case .showConvertAlert(let message):
                    let cancelButton = AlertModel(title: "Cancel", style: .cancel)
                    let convertButton = AlertModel(title: "Convert", style: .default)
                    
                    return self.alertPresenter.present(title: "Alert",
                                                       message: message,
                                                       actions: [cancelButton,
                                                                 convertButton],
                                                       viewController: self)
                case .showErrorAlert(let message):
                    let cancelButton = AlertModel(title: "Cancel", style: .cancel)
                    return self.alertPresenter.present(title: "Error",
                                                       message: message,
                                                       actions: [cancelButton],
                                                       viewController: self)
                default:
                    return Observable.empty()
                }
        }
        .filter({ $0 == .alertButtonTapped(buttonIndex: 1)})
        .map { _ in ()}
        .bind(to: viewModel.convertConfirmed)
        .disposed(by: disposeBag)
    }
    
    private func setupShowTransactionButton() {
        let showTransactionButton = UIBarButtonItem(image: UIImage(systemName: "arrow.right.arrow.left"),
                                        style: .plain,
                                        target: self,
                                        action: nil)
        
        showTransactionButton.tintColor = UIColor(named: "FontColor")
        self.navigationItem.rightBarButtonItem = showTransactionButton
        
        showTransactionButton.rx.tap
            .bind(to: viewModel.showTransactionButtonClicked)
            .disposed(by: disposeBag)
    }
    
    func fetchExchangeRates() {
        viewModel.latestRateRequest.onNext(())
    }
    
    private func setupFromPickerView() {
        viewModel.currencyCodes.asObservable()
            .bind(to: self.fromPickerView.rx.itemTitles) {$1}
            .disposed(by: disposeBag)
        
        self.fromPickerView.rx.itemSelected
            .map { [weak self] selected in
                return self?.viewModel.currencyCodes.value[selected.row]}
            .bind(to: self.fromCurrencyCodeTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupToPickerView() {
        viewModel.currencyCodes.asObservable()
            .bind(to: self.toPickerView.rx.itemTitles) {$1}
            .disposed(by: disposeBag)
        
        self.toPickerView.rx.itemSelected
            .map { [weak self] selected in
                return self?.viewModel.currencyCodes.value[selected.row]}
            .bind(to: self.toCurrencyCodeTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
