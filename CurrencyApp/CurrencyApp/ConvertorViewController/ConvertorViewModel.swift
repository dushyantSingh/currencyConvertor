//
//  ConvertorViewModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

class ConvertorViewModel {
    let title = "Convert"
    let currencyService: CurrencyServiceType
    let transactionDB: RealmDbType
    let wallet: WalletType
    
    let convertButtonClicked = PublishSubject<Void>()
    let convertConfirmed = PublishSubject<Void>()
    let latestRateRequest = PublishSubject<Void>()
    let showTransactionButtonClicked = PublishSubject<Void>()
    let events = PublishSubject<ConvertorViewModelEvents>()
    
    let exchangeRates: BehaviorRelay<[String: Double]> = BehaviorRelay(value: [:])
    let currencyCodes: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let fromCurrency: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let toCurrency: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let fromCurrencyCode: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let toCurrencyCode: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    let skipCalculation: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let walletBalance: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
   
    private  var areFieldsValid: Bool {
        return  !(self.fromCurrencyCode.value.isEmpty ||
            self.fromCurrency.value.isEmpty   ||
            self.toCurrencyCode.value.isEmpty ||
            self.toCurrency.value.isEmpty) &&
            (Double(self.fromCurrency.value) != nil) &&
            (Double(self.toCurrency.value) != nil)
    }
    private var convertAlertMessage: String {
        if areFieldsValid {
            return "Are you sure you want to convert \(self.fromCurrencyCode.value) \(self.fromCurrency.value) to \(self.toCurrencyCode.value) \(self.toCurrency.value)?"
        }
        return "Please fill all fields before conversion."
    }
    
    private var currentTransactionModel: TransactionModel {
        let id = self.transactionDB.initializeId()
        guard let doubleFromCurrency = Double(self.fromCurrency.value),
        let doubleToCurrency = Double(self.toCurrency.value) else {
          fatalError("Currency value found nil while unwrapping")
        }
        return  TransactionModel(id: id,
                                transactionId: "CVRT\(id)",
                                transactionDate: Date(),
                                fromCurrencyCode: self.fromCurrencyCode.value,
                                fromCurrency: doubleFromCurrency,
                                toCurrencyCode: self.toCurrencyCode.value,
                                toCurrency: doubleToCurrency,
                                exchangeRate: doubleToCurrency/doubleFromCurrency)
    }
    
    init(currencyService: CurrencyServiceType,
         transactionDB: RealmDbType,
         wallet: WalletType) {
        self.transactionDB = transactionDB
        self.currencyService = currencyService
        self.wallet = wallet
        setupWallet()
        setupCalculation()
        setupEvents()
        setupFetch()

    }
}

extension ConvertorViewModel {
    private func setupWallet() {
        self.wallet.balance.asObservable()
            .map { String(format: "SGD %.2f", $0)}
            .bind(to: self.walletBalance)
            .disposed(by: disposeBag)
    }

    private func setupEvents() {
        convertButtonClicked.asObservable()
            .map{ [weak self ] _ in
                self?.convertAlertMessage }
            .filterNil()
            .map{ [weak self ] message in
                (self?.areFieldsValid ?? false) ?
                    .showConvertAlert(message: message) :
                    .showErrorAlert(message: message)}
            .bind(to: events)
            .disposed(by: disposeBag)
        
        showTransactionButtonClicked.asObservable()
            .map { .showTransactionView }
            .bind(to: self.events)
            .disposed(by: disposeBag)
        
        convertConfirmed.asObservable()
            .subscribe(onNext: { [weak self]_ in
                guard let self = self else { return }
                let transactionModel = self.currentTransactionModel
                let transactionObject = TransactionObject(transactionModel: transactionModel)
                self.transactionDB.save(object: transactionObject)
                let moneySpentInSGD = self.convertToSGD(money: transactionModel.fromCurrency,
                                                   currencyCode: transactionModel.fromCurrencyCode)
                self.wallet.takeMoney(moneySpentInSGD)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFetch() {
        latestRateRequest.asObservable()
            .map { CurrencyRequest.exchangeRequest(baseURL: Enviornment.manager.baseURL)}
            .flatMap { [weak self] request -> Observable<ExchangeModel> in
                guard let self = self else { return Observable.empty() }
                return self.currencyService.retrieve(request: request)}
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { rates in
                    var exchangeRates = rates.rates
                    exchangeRates[rates.base] = 1.0
                    self.exchangeRates.accept(exchangeRates)
                    self.currencyCodes.accept(exchangeRates.keys.sorted())
                    self.fromCurrencyCode.accept(rates.base)
                    self.toCurrencyCode.accept(rates.base) },
                
                onError: { error in
                    self.events.onNext(.showErrorAlert(message: error.localizedDescription))})
            .disposed(by: disposeBag)
    }
    private func setupCalculation() {
        Observable.combineLatest(self.fromCurrency,
                                 self.fromCurrencyCode,
                                 self.toCurrencyCode,
                                 self.exchangeRates)
            .filter { _ in !self.skipCalculation.value }
            .calculateExchangeToCurrency()
            .bind(to: self.toCurrency)
            .disposed(by: disposeBag)
        
        self.toCurrency.asObservable()
            .filter { _ in self.skipCalculation.value }
            .map {($0,
                   self.toCurrencyCode.value,
                   self.fromCurrencyCode.value,
                   self.exchangeRates.value) }
            .calculateExchangeToCurrency()
            .bind(to: self.fromCurrency)
            .disposed(by: disposeBag)
    }
}
extension ConvertorViewModel {
    func convertToSGD(money: Double, currencyCode: String) -> Double {
        let exchangeRateForSGD: Double = self.exchangeRates.value["SGD"]!
        let exchangeRateForGivenCurrecy: Double = self.exchangeRates.value[currencyCode]!
        
        return money * (exchangeRateForSGD/exchangeRateForGivenCurrecy)
    }
}
