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
            var disposeBag: DisposeBag!
            
            beforeEach {
                subject = UIViewController.make(viewController: ConvertorViewController.self)
                mockCurrencyService = MockCurrencyService()
                disposeBag = DisposeBag()
                subject.viewModel = ConvertorViewModel(currencyService: mockCurrencyService)
                _ = subject.view
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
                    subject.viewDidLoad()
                    expect(isLatestRateRequestCalled).to(beTrue())
                }
                it("should retrieve called") {
                    mockCurrencyService.isRetrieveCalled = false
                    subject.viewDidLoad()
                    expect(mockCurrencyService.isRetrieveCalled).to(beTrue())
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
                    subject.viewModel.events.onNext(.showConvertAlert)
                    expect(mockAlertView.isAlertViewPresented).to(beTrue())
                }
                it("should show alert view title") {
                    subject.viewModel.events.onNext(.showConvertAlert)
                    expect(mockAlertView.title).to(equal("Alert"))
                }
                it("should show alert view message") {
                    subject.viewModel.events.onNext(.showConvertAlert)
                    expect(mockAlertView.message)
                        .to(equal("Are you sure you want to convert?"))
                }
                it("should show have actions") {
                    subject.viewModel.events.onNext(.showConvertAlert)
                    expect(mockAlertView.actions.count).to(equal(2))
                }
                it("should show trigger confirm conversion") {
                    subject.viewModel
                        .events
                        .onNext(.showConvertAlert)
                    var convertConfirmTriggered = false
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
        }
    }
}

