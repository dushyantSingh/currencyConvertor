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
            var disposeBag: DisposeBag!
            beforeEach {
                subject = UIViewController.make(viewController: ConvertorViewController.self)
                disposeBag = DisposeBag()
                subject.viewModel = ConvertorViewModel()
                 _ = subject.view
            }
            context("when view loads") {
                it("should have title") {
                    expect(subject.title).to(equal("Convert"))
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
        }
    }
}

class MockAlertView: AlertViewPresenterType {
    var isAlertViewPresented = false
    var title = ""
    var message = ""
    var actions: [AlertModel] = []
    var convertButtonClicked = PublishSubject<AlertModelEvent>()
    
    func present(title: String,
                 message: String,
                 actions: [AlertModel],
                 viewController: UIViewController) -> Observable<AlertModelEvent> {
        isAlertViewPresented = true
        self.title = title
        self.message = message
        self.actions = actions
        return convertButtonClicked.asObservable()
    }
}
