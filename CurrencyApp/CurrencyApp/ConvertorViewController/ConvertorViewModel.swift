//
//  ConvertorViewModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
import RxCocoa


class ConvertorViewModel {
    let title = "Convert"
    
    let convertButtonClicked = PublishSubject<Void>()
    let convertConfirmed = PublishSubject<Void>()
    let events = PublishSubject<ConvertViewModelEvents>()
    let rates: BehaviorRelay<ExchangeModel> = BehaviorRelay(value: ExchangeModel(rates: [:],
                                                   base: "EUR",
                                                   date: ""))
    let latestRateRequest = PublishSubject<Void>()
    let currencyService: CurrencyServiceType
    let fromCurrency = BehaviorRelay<String>(value: "")
    let toCurrency = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
   
    init(currencyService: CurrencyServiceType) {
        self.currencyService = currencyService
        setupEvents()
        setupFetch()
    }
}

extension ConvertorViewModel {
    private func setupEvents() {
        convertButtonClicked.asObservable()
            .map{.showConvertAlert}
            .bind(to: events)
            .disposed(by: disposeBag)
        
        convertConfirmed.asObservable().subscribe(onNext: {_ in
            print("Calculate conversion")
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
            .subscribe(onNext: { rates in
                self.rates.accept(rates)},
                       onError: { error in
                        self.events
                            .onNext(.showErrorAlert(message: error.localizedDescription))})
            .disposed(by: disposeBag)
    }
}
