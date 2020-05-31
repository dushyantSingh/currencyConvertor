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
            var mockTransactionDb: MockTransactionDb!
            var disposeBag: DisposeBag!
            beforeEach {
                mockCurrencyService = MockCurrencyService()
                mockTransactionDb = MockTransactionDb()
                subject = ConvertorViewModel(currencyService: mockCurrencyService,
                                             transactionDB: mockTransactionDb)
                disposeBag = DisposeBag()
            }
            context("When convert button is triggered") {
                var showErrorAlertEvent: Bool!
                var showConvertAlertEvent: Bool!
                var actualMessage: String!
                
                beforeEach {
                    showConvertAlertEvent = false
                    showErrorAlertEvent = false
                    actualMessage = ""
                    subject.events
                        .subscribe(onNext: { event in
                            switch event {
                            case .showErrorAlert(let message):
                                showErrorAlertEvent = true
                                actualMessage = message
                            case .showConvertAlert(let message):
                                showConvertAlertEvent = true
                                actualMessage = message
                            default : break
                            }})
                        .disposed(by: disposeBag)
                }
                
                it("should emit showErrorAlert event when no fields are filled") {
                    let expectedMessage = "Please fill all fields before conversion."
                    subject.convertButtonClicked.onNext(())
                    expect(showErrorAlertEvent).to(beTrue())

                    expect(showConvertAlertEvent).to(beFalse())
                    expect(actualMessage).to(equal(expectedMessage))
                }
                it("should emit showErrorAlert event when only from currency code is filled") {
                    let expectedMessage = "Please fill all fields before conversion."
                    subject.fromCurrencyCode.accept("SGD")
                    subject.convertButtonClicked.onNext(())

                    expect(showErrorAlertEvent).to(beTrue())
                    expect(showConvertAlertEvent).to(beFalse())
                    expect(actualMessage).to(equal(expectedMessage))
                }
                it("should emit showErrorAlert event when from currency code and from currency is filled") {
                    let expectedMessage = "Please fill all fields before conversion."
                    subject.fromCurrencyCode.accept("SGD")
                    subject.fromCurrency.accept("100")
                    subject.convertButtonClicked.onNext(())

                    expect(showErrorAlertEvent).to(beTrue())
                    expect(showConvertAlertEvent).to(beFalse())
                    expect(actualMessage).to(equal(expectedMessage))
                }
                it("should emit showErrorAlert event when from currency code, from currency and to currency code is filled") {
                    let expectedMessage = "Please fill all fields before conversion."
                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrencyCode.accept("EUR")
                    subject.fromCurrency.accept("100")
                    subject.convertButtonClicked.onNext(())
                    
                    expect(showErrorAlertEvent).to(beTrue())
                    expect(showConvertAlertEvent).to(beFalse())
                    expect(actualMessage).to(equal(expectedMessage))
                }
                it("should emit showConvertAlert event when all fields are filled") {
                    let expectedMessage = "Are you sure you want to convert SGD 100 to EUR 1000?"

                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrencyCode.accept("EUR")
                    subject.fromCurrency.accept("100")
                    subject.toCurrency.accept("1000")

                    subject.convertButtonClicked.onNext(())

                    expect(showConvertAlertEvent).to(beTrue())
                    expect(actualMessage).to(equal(expectedMessage))
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
            context("When calculation is triggered") {
                beforeEach {
                    subject.exchangeRates.accept(MockExchangeRateFactory.mockRates)
                }
                context("when from currency is changed") {
                    beforeEach {
                        subject.toCurrencyCode.accept("SGD")
                        subject.fromCurrencyCode.accept("USD")
                        subject.toCurrency.accept("")
                        subject.fromCurrency.accept("")
                        subject.skipCalculation.accept(false)
                    }
                    it("should convert 100 USD to SGD") {
                        subject.fromCurrency.accept("100")
                        expect(subject.toCurrency.value).to(equal("141.80"))
                    }
                    it("should convert 250 USD to SGD") {
                        subject.fromCurrency.accept("250")
                        expect(subject.toCurrency.value).to(equal("354.51"))
                    }
                }
                context("when from currency code is changed") {
                    beforeEach {
                        subject.toCurrencyCode.accept("SGD")
                        subject.fromCurrencyCode.accept("")
                        subject.toCurrency.accept("")
                        subject.fromCurrency.accept("1000")
                        subject.skipCalculation.accept(false)
                    }
                    it("should convert 1000 IDR to SGD") {
                        subject.fromCurrencyCode.accept("IDR")
                        expect(subject.toCurrency.value).to(equal("0.10"))
                    }
                    it("should convert 1000 INR to SGD") {
                        subject.fromCurrencyCode.accept("INR")
                        expect(subject.toCurrency.value).to(equal("18.72"))
                    }
                }
                context("when to currency code is changed") {
                    beforeEach {
                        subject.toCurrencyCode.accept("")
                        subject.fromCurrencyCode.accept("EUR")
                        subject.toCurrency.accept("")
                        subject.fromCurrency.accept("90")
                        subject.skipCalculation.accept(false)
                    }
                    it("should convert 90 EUR to SGD") {
                        subject.toCurrencyCode.accept("SGD")
                        expect(subject.toCurrency.value).to(equal("140.59"))
                    }
                    it("should convert 90 EUR to INR") {
                        subject.toCurrencyCode.accept("INR")
                        expect(subject.toCurrency.value).to(equal("7511.71"))
                    }
                }
                context("when to currency is changed") {
                    beforeEach {
                        subject.toCurrencyCode.accept("SEK")
                        subject.fromCurrencyCode.accept("SGD")
                        subject.toCurrency.accept("")
                        subject.fromCurrency.accept("")
                        subject.skipCalculation.accept(true)
                    }
                    it("should convert 120 SEK to SGD") {
                        subject.toCurrency.accept("120")
                        expect(subject.fromCurrency.value).to(equal("17.77"))
                    }
                    it("should convert 250 SEK to SGD") {
                        subject.toCurrency.accept("250")
                        expect(subject.fromCurrency.value).to(equal("37.02"))
                    }
                }
                context("when showTransactionClicked is triggered") {
                    it("should emit showTransactonView event") {
                        var isShowTransactionViewEvent = false
                        subject.events
                            .subscribe(onNext: { event in
                                if case .showTransactionView = event {
                                    isShowTransactionViewEvent = true
                                }})
                            .disposed(by: disposeBag)
                        subject.showTransactionButtonClicked.onNext(())
                        expect(isShowTransactionViewEvent).to(beTrue())
                    }
                }
                context("when convertConfirmed is triggered") {
                    it("should save transaction object to realm event") {
                        subject.skipCalculation.accept(true)
                        subject.toCurrencyCode.accept("USD")
                        subject.fromCurrencyCode.accept("SGD")
                        subject.toCurrency.accept("800")
                        subject.fromCurrency.accept("1000")
                        subject.convertConfirmed.onNext(())
                        guard let transactionObj = mockTransactionDb.saveTransactionCalledWithObject as? TransactionObject else {
                            fail("Save called with wrong object")
                            return
                        }
                        expect(transactionObj.id).to(equal(101))
                        expect(transactionObj.transactionId).to(equal("CVRT101"))
                        expect(transactionObj.transactionDate.toString()).to(equal(Date().toString()))
                        expect(transactionObj.toCurrencyCode).to(equal("USD"))
                        expect(transactionObj.fromCurrencyCode).to(equal("SGD"))
                        expect(transactionObj.toCurrency).to(equal(800))
                        expect(transactionObj.fromCurrency).to(equal(1000))
                        expect(transactionObj.exchangeRate).to(equal(0.80))
                        
                    }
                }
                it("should save transaction object2 to realm event") {
                    subject.skipCalculation.accept(true)
                    subject.toCurrencyCode.accept("INR")
                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrency.accept("50000")
                    subject.fromCurrency.accept("1000")
                    subject.convertConfirmed.onNext(())
                    guard let transactionObj = mockTransactionDb.saveTransactionCalledWithObject as? TransactionObject else {
                        fail("Save called with wrong object")
                        return
                    }
                    expect(transactionObj.id).to(equal(101))
                    expect(transactionObj.transactionId).to(equal("CVRT101"))
                    expect(transactionObj.transactionDate.toString()).to(equal(Date().toString()))
                    expect(transactionObj.toCurrencyCode).to(equal("INR"))
                    expect(transactionObj.fromCurrencyCode).to(equal("SGD"))
                    expect(transactionObj.toCurrency).to(equal(50000))
                    expect(transactionObj.fromCurrency).to(equal(1000))
                    expect(transactionObj.exchangeRate).to(equal(50.00))
                }
            }
        }
    }
}

class MockError: Error {
}
