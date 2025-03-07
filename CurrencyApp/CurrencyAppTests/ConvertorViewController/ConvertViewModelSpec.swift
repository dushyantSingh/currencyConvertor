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
            var mockWallet: MockWallet!
            var disposeBag: DisposeBag!
            beforeEach {
                mockCurrencyService = MockCurrencyService()
                mockTransactionDb = MockTransactionDb()
                mockWallet = MockWallet()
                subject = ConvertorViewModel(currencyService: mockCurrencyService,
                                             transactionDB: mockTransactionDb,
                                             wallet: mockWallet)
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
                    subject.exchangeRates.accept(MockExchangeRateFactory.mockRates)
                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrencyCode.accept("EUR")
                    subject.fromCurrency.accept("100")
                    subject.toCurrency.accept("1000")

                    subject.convertButtonClicked.onNext(())

                    expect(showConvertAlertEvent).to(beTrue())
                    expect(actualMessage).to(equal(expectedMessage))
                }
                it("should emit showErrorAlert when wallet has less balance than requested money") {
                    let expectedMessage = "Insufficient balance in wallet"
                    subject.exchangeRates.accept(MockExchangeRateFactory.mockRates)
                    mockWallet.canTakeMoney = false
                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrencyCode.accept("EUR")
                    subject.fromCurrency.accept("1000")
                    subject.toCurrency.accept("1000")

                    subject.convertButtonClicked.onNext(())

                    expect(showErrorAlertEvent).to(beTrue())
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
                it("should save exchange rates on retrieve latest") {
                    let mockData = ExchangeModel(rates: ["SGD" : 1.5], base: "EUR", date: "Today")
                    subject.latestRateRequest.onNext(())
                    mockCurrencyService.onRetrieve.onNext(mockData)
                    let expectecObj = ExchangeObject(exchangeModel: mockData)
                   let actualObj = mockTransactionDb.saveTransactionCalledWithObject as! ExchangeObject
                    expect(actualObj.rates).to(equal(expectecObj.rates))
                    expect(actualObj.base).to(equal(expectecObj.base))
                    expect(actualObj.date).to(equal(expectecObj.date))
                }
                it("should add base exchange rate to exchange rates") {
                    let mockData = ExchangeModel(rates: ["SGD" : 1.5], base: "EUR", date: "Today")
                    subject.latestRateRequest.onNext(())
                    mockCurrencyService.onRetrieve.onNext(mockData)
                    expect(subject.exchangeRates.value.count).to(equal(2))
                    expect(subject.exchangeRates.value["EUR"]).to(equal(1.0))
                    expect(subject.exchangeRates.value["SGD"]).to(equal(1.5))
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
                it("should use saved exchange rates when retrieve fails") {
                    let error = MockError()
                    subject.latestRateRequest.onNext(())
                    mockCurrencyService.onRetrieve.onError(error)
                    expect(mockTransactionDb.fetchTransactionsCalled).toEventually(beTrue())
                }
                it("should add base exchange rate to exchange rates when retrieve fails") {
                    let mockExchangeModel = ExchangeModel(rates: ["SGD" : 1.5],
                                                          base: "EUR",
                                                          date: "Today")
                    let mockExchangeObject = ExchangeObject(exchangeModel: mockExchangeModel)
                    mockTransactionDb.realmObject = [mockExchangeObject]
                    let error = MockError()
                    subject.latestRateRequest.onNext(())
                    mockCurrencyService.onRetrieve.onError(error)
                    expect(subject.exchangeRates.value.count).to(equal(2))
                    expect(subject.exchangeRates.value["EUR"]).to(equal(1.0))
                    expect(subject.exchangeRates.value["SGD"]).to(equal(1.5))
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
                it("should call wallet take money") {
                    subject.skipCalculation.accept(true)
                    subject.toCurrencyCode.accept("INR")
                    subject.fromCurrencyCode.accept("SGD")
                    subject.toCurrency.accept("50000")
                    subject.fromCurrency.accept("1000")
                    mockWallet.takeMoneyCalled = false
                    
                    subject.convertConfirmed.onNext(())
                    expect(mockWallet.takeMoneyCalled).to(beTrue())
                }
                context("when wallet balace is changed") {
                    it("should update wallet balance in view model") {
                        var actualBalance = ""
                        subject.walletBalance
                            .subscribe(onNext: { balance in
                                actualBalance = balance })
                            .disposed(by: disposeBag)
                        mockWallet.mockBalance.accept(10.90)
                        expect(actualBalance).to(equal(("SGD 10.90")))
                    }
                    it("should update wallet balance in view model") {
                        var actualBalance = ""
                        subject.walletBalance
                            .subscribe(onNext: { balance in
                                actualBalance = balance })
                            .disposed(by: disposeBag)
                        mockWallet.mockBalance.accept(100.20)
                        expect(actualBalance).to(equal(("SGD 100.20")))
                    }
                }
                context("when convert to sgd is called") {
                    it("should return value in sgd") {
                        subject.latestRateRequest.onNext(())
                        let actualBalance = subject.convertToSGD(money: 1000, currencyCode: "INR")
                        let actualBalanceString = String(format: "%.2f", actualBalance)
                        expect(actualBalanceString).to(equal("18.72"))
                    }
                    it("should return value in sgd for USD") {
                        subject.latestRateRequest.onNext(())
                        let actualBalance = subject.convertToSGD(money: 1000, currencyCode: "USD")
                        let actualBalanceString = String(format: "%.2f", actualBalance)
                        expect(actualBalanceString).to(equal("1418.03"))
                    }
                }
            }
        }
    }
}

class MockError: Error {
}
