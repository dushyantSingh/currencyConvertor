//
//  ConvertorViewControllerSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp
class ConvertorViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ConvertorViewController Test") {
            var subject: ConvertorViewController!
            var mockCurrencyService: MockCurrencyService!
            var mockDb: MockTransactionDb!
            var mockWallet: MockWallet!
            var disposeBag: DisposeBag!
            
            beforeEach {
                subject = UIViewController.make(viewController: ConvertorViewController.self)
                mockCurrencyService = MockCurrencyService()
                mockDb = MockTransactionDb()
                mockWallet = MockWallet()
                disposeBag = DisposeBag()
                
                subject.viewModel = ConvertorViewModel(currencyService: mockCurrencyService,
                                                       transactionDB: mockDb,
                                                       wallet: mockWallet)
                _ = subject.view
            }
            
            func selectRow(_ pickerView: UIPickerView, row: Int) {
                pickerView.delegate?.pickerView?(pickerView,
                                                 didSelectRow: row,
                                                 inComponent: 0)
            }
            
            context("when view loads") {
                it("should have title") {
                    expect(subject.title).to(equal("Convert"))
                }
                it("should latestRateRequest called") {
                    var isLatestRateRequestCalled = false
                    subject.viewModel
                        .latestRateRequest
                        .subscribe(onNext: {_ in
                            isLatestRateRequestCalled = true
                        })
                        .disposed(by: disposeBag)
                    subject.fetchExchangeRates()
                    expect(isLatestRateRequestCalled).to(beTrue())
                }
                it("should retrieve called") {
                    mockCurrencyService.isRetrieveCalled = false
                    subject.fetchExchangeRates()
                    expect(mockCurrencyService.isRetrieveCalled).to(beTrue())
                }
                it("should display wallet balance") {
                    mockWallet.mockBalance.accept(100.20)
                    expect(subject.walletBalanceLabel.text).to(equal("SGD 100.20"))
                }
            }
            context("when convert button is clicked") {
                it("should trigger convertButtonClicked in view model") {
                    var convertButtonTriggered = false
                    subject.viewModel.convertButtonClicked
                        .subscribe(onNext: { _ in
                            convertButtonTriggered = true
                        })
                        .disposed(by: disposeBag)
                    subject.convertButton.sendActions(for: .touchUpInside)
                    expect(convertButtonTriggered).to(beTrue())
                }
            }
            context("when show alert event is pushed") {
                var mockAlertView: MockAlertView!
                beforeEach {
                    mockAlertView = MockAlertView()
                    subject.alertPresenter = mockAlertView
                }
                it("should show alert view") {
                    subject.viewModel
                        .events
                        .onNext(.showConvertAlert(message:"Some message"))
                    expect(mockAlertView.isAlertViewPresented).to(beTrue())
                }
                it("should show alert view title") {
                    subject.viewModel
                        .events
                        .onNext(.showConvertAlert(message:"Some message"))
                    expect(mockAlertView.title).to(equal("Alert"))
                }
                it("should show alert view message") {
                    subject.viewModel
                        .events
                        .onNext(.showConvertAlert(message:"Some message"))
                    expect(mockAlertView.message)
                        .to(equal("Some message"))
                }
                it("should show have actions") {
                    subject.viewModel.events.onNext(.showConvertAlert(message:"Some message"))
                    expect(mockAlertView.actions.count).to(equal(2))
                }
                it("should show trigger confirm conversion") {
                    subject.viewModel
                        .events
                        .onNext(.showConvertAlert(message:"Some message"))
                    var convertConfirmTriggered = false
                    subject.viewModel.exchangeRates.accept(MockExchangeRateFactory.mockRates)
                    subject.viewModel.fromCurrencyCode.accept("SGD")
                    subject.viewModel.fromCurrency.accept("100")
                    subject.viewModel.toCurrency.accept("100")
                    subject.viewModel
                        .convertConfirmed
                        .subscribe(onNext: {_ in
                            convertConfirmTriggered = true
                        })
                        .disposed(by: disposeBag)
                    
                    mockAlertView.convertButtonClicked
                        .onNext(.alertButtonTapped(buttonIndex: 1))
                    
                    expect(convertConfirmTriggered).to(beTrue())
                }
            }
            
            context("when show error alert event is pushed") {
                var mockAlertView: MockAlertView!
                beforeEach {
                    mockAlertView = MockAlertView()
                    subject.alertPresenter = mockAlertView
                }
                it("should show alert view") {
                    subject.viewModel
                        .events
                        .onNext(.showErrorAlert(message: "Failed"))
                    expect(mockAlertView.isAlertViewPresented).to(beTrue())
                }
                it("should show alert view title") {
                    subject.viewModel
                        .events
                        .onNext(.showErrorAlert(message: "Failed"))
                    expect(mockAlertView.title).to(equal("Error"))
                }
                it("should show alert view message") {
                    subject.viewModel
                        .events
                        .onNext(.showErrorAlert(message: "Failed"))
                    expect(mockAlertView.message)
                        .to(equal("Failed"))
                }
                it("should show have cancel button") {
                    subject.viewModel.events.onNext(.showErrorAlert(message: "Failed"))
                    expect(mockAlertView.actions.count).to(equal(1))
                }
            }
            context("when from currency textfield is edited") {
                it("should update from currency in view model") {
                    subject.fromCurrencyTextField.text = "100"
                    subject.fromCurrencyTextField.sendActions(for: .editingDidEnd)
                    expect(subject.viewModel.fromCurrency.value).to(equal("100"))
                }
                it("should update from currency in view model") {
                    subject.fromCurrencyTextField.text = "200"
                    subject.fromCurrencyTextField.sendActions(for: .editingDidEnd)
                    expect(subject.viewModel.fromCurrency.value).to(equal("200"))
                }
            }
            context("when to currency textfield is edited") {
                it("should update to currency in view model") {
                    subject.toCurrencyTextField.text = "400"
                    subject.toCurrencyTextField.sendActions(for: .editingDidEnd)
                    expect(subject.viewModel.toCurrency.value).to(equal("400"))
                }
                it("should update to currency in view model") {
                    subject.toCurrencyTextField.text = "230"
                    subject.toCurrencyTextField.sendActions(for: .editingDidEnd)
                    expect(subject.viewModel.toCurrency.value).to(equal("230"))
                }
            }
            context("when to picker view is reloaded") {
                it("should display all currency codes") {
                    subject.viewModel.currencyCodes.accept(["SGD", "EUR", "USD"])
                    expect(subject.toPickerView.numberOfRows(inComponent: 0))
                        .to(equal(3))
                }
                it("should display all currency codes") {
                    let codes = ["SGD", "EUR", "USD", "AUD", "INR"]
                    subject.viewModel.currencyCodes.accept(codes)
                    expect(subject.toPickerView.numberOfRows(inComponent: 0))
                        .to(equal(5))
                }
            }
            
            context("when from picker view is reloaded") {
                it("should display all currency codes") {
                    subject.viewModel.currencyCodes.accept(["SGD", "EUR", "USD", "INR"])
                    expect(subject.fromPickerView.numberOfRows(inComponent: 0))
                        .to(equal(4))
                }
                it("should display all currency codes") {
                    let codes = ["SGD", "EUR", "USD", "AUD", "IDR", "INR"]
                    subject.viewModel.currencyCodes.accept(codes)
                    expect(subject.fromPickerView.numberOfRows(inComponent: 0))
                        .to(equal(6))
                }
            }
            context("when to currency code textfield is edited") {
                beforeEach {
                    let codes = ["SGD", "EUR", "USD", "AUD", "INR"]
                    subject.viewModel.currencyCodes.accept(codes)
                }
                it("should update 'to' textfield with SGD code from picker selection") {
                    selectRow(subject.toPickerView, row: 1)
                    subject.toCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.toCurrencyCodeTextField.text).to(equal("EUR"))
                    expect(subject.viewModel.toCurrencyCode.value).to(equal("EUR"))
                }
                it("should update 'to' textfield with AUD code from picker selection") {
                    selectRow(subject.toPickerView, row: 3)
                    subject.toCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.toCurrencyCodeTextField.text).to(equal("AUD"))
                    expect(subject.viewModel.toCurrencyCode.value).to(equal("AUD"))
                }
                it("should update 'to' textfield with AUD code from picker selection") {
                    selectRow(subject.toPickerView, row: 4)
                    subject.toCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.toCurrencyCodeTextField.text).to(equal("INR"))
                    expect(subject.viewModel.toCurrencyCode.value).to(equal("INR"))
                }
                
            }
            context("when from currency code textfield is edited") {
                beforeEach {
                    let codes = ["IDR", "EUR", "USD", "AUD", "INR", "SGD", "DDD"]
                    subject.viewModel.currencyCodes.accept(codes)
                }
                it("should update 'from' textfield with SGD code from picker selection") {
                    selectRow(subject.fromPickerView, row: 0)
                    subject.fromCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.fromCurrencyCodeTextField.text).to(equal("IDR"))
                    expect(subject.viewModel.fromCurrencyCode.value).to(equal("IDR"))
                }
                it("should update 'from' textfield with AUD code from picker selection") {
                    selectRow(subject.fromPickerView, row: 4)
                    subject.fromCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.fromCurrencyCodeTextField.text).to(equal("INR"))
                    expect(subject.viewModel.fromCurrencyCode.value).to(equal("INR"))
                }
                it("should update 'from' textfield with AUD code from picker selection") {
                    selectRow(subject.fromPickerView, row: 6)
                    subject.fromCurrencyCodeTextField.sendActions(for: .editingDidEnd)
                    expect(subject.fromCurrencyCodeTextField.text).to(equal("DDD"))
                    expect(subject.viewModel.fromCurrencyCode.value).to(equal("DDD"))
                }
            }
            context("when to currency textfield is editing") {
                it("should update skip calculation in view model") {
                    subject.toCurrencyTextField.sendActions(for: .editingDidBegin)
                    expect(subject.viewModel.skipCalculation.value).to(beTrue())
                }
                it("should update skip calculation in view model") {
                    subject.toCurrencyTextField.sendActions(for: .editingDidEnd)
                    expect(subject.viewModel.skipCalculation.value).to(beFalse())
                }
            }
            context("when show transaction button is clicked") {
                it("should trigger showTransactionButtonClicked in view model") {
                    var showTransactionTriggered = false
                    subject.viewModel.showTransactionButtonClicked
                        .subscribe(onNext: { _ in
                            showTransactionTriggered = true
                        })
                        .disposed(by: disposeBag)
                    guard let showButton = subject.navigationItem.rightBarButtonItem else {
                        fail("No showTransaction button found")
                        return
                    }
                    
                    UIApplication.shared
                        .sendAction(showButton.action!,
                                    to: showButton.target!,
                                    from: nil,
                                    for: nil)
                    expect(showTransactionTriggered).to(beTrue())
                }
            }
        }
    }
}
