//
//  ConvertViewModelSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class ConvertorViewModelSpec: QuickSpec {
    override func spec() {
        describe("ConvertorViewModel Test") {
            var subject: ConvertorViewModel!
            var mockCurrencyService: MockCurrencyService!
            var disposeBag: DisposeBag!
            beforeEach {
                mockCurrencyService = MockCurrencyService()
                subject = ConvertorViewModel(currencyService: mockCurrencyService)
                disposeBag = DisposeBag()
            }
            context("When convert button is triggered") {
                it("should emit event showConvertAlert") {
                    var showConvertAlertEvent = false
                    subject.events.subscribe(onNext: { event in
                        if case .showConvertAlert = event {
                            showConvertAlertEvent = true
                        }
                    })
                    .disposed(by: disposeBag)
                    subject.convertButtonClicked.onNext(())
                    expect(showConvertAlertEvent).to(beTrue())
                }
            }
            context("When latest exchange rate is triggered") {
                it("should call retrieve") {
                    mockCurrencyService.isRetrieveCalled = false
                    subject.latestRateRequest.onNext(())
                    expect(mockCurrencyService.isRetrieveCalled).to(beTrue())
                }
                it("should retrieve latest exchange rate") {
                    let mockData = ExchangeModel(rates: ["SGD" : 1.5], base: "EUR", date: "Today")
                    subject.latestRateRequest.onNext(())
                    mockCurrencyService.onRetrieve.onNext(mockData)
                    expect(subject.exchangeRates.value.count)
                        .toEventually(equal(2))
                    expect(subject.exchangeRates.value["SGD"])
                        .toEventually(equal(1.5))
                }
                it("should emit show error alert event when retrieve fails") {
                    let error = MockError()
                    subject.latestRateRequest.onNext(())
                    var isShowErrorAlertEvent = false
                    subject.events
                        .subscribe(onNext: { event in
                            if case .showErrorAlert = event {
                                isShowErrorAlertEvent = true
                        }})
                        .disposed(by: disposeBag)
                    mockCurrencyService.onRetrieve.onError(error)
                    expect(isShowErrorAlertEvent).toEventually(beTrue())
                }
            }
        }
    }
}

class MockError: Error {
}
