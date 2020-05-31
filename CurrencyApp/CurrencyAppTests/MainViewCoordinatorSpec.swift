//
//  MainViewCoordinator.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class MainViewCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("MainViewCoordinator Test") {
            var subject: MainViewCoordinator!
            var mockNavigationController: MockNavigationController!
           
            beforeEach {
                mockNavigationController = MockNavigationController()
                subject = MainViewCoordinator()
                subject.navigationController = mockNavigationController
            }
            context("when navigation action emits push") {
                context("when view model is ConvertorViewModel") {
                    var mockService: CurrencyServiceType!
                    beforeEach {
                        mockService = MockCurrencyService()
                        let viewModel = ConvertorViewModel(currencyService: mockService)
                        subject.viewModelCoordinator
                            .navigationAction.onNext(.push(viewModel: viewModel,
                                                           animated: true))
                    }
                    it("should push a view controller") {
                        expect(mockNavigationController.pushViewControllerCalled)
                            .to(beTrue())
                    }
                    it("should push ConvertorViewController") {
                        expect(mockNavigationController.viewController)
                            .to(beAKindOf(ConvertorViewController.self))
                    }
                }
                context("when view model is TransactionViewModel") {
                    beforeEach {
                        let stub = TransactionStub.transactions
                        let viewModel = TransactionViewModel(transactions: stub)
                        subject.viewModelCoordinator
                            .navigationAction.onNext(.push(viewModel: viewModel,
                                                           animated: true))
                    }
                    it("should push a view controller") {
                        expect(mockNavigationController.pushViewControllerCalled)
                            .to(beTrue())
                    }
                    it("should push TransactionViewController") {
                        expect(mockNavigationController.viewController)
                            .to(beAKindOf(TransactionViewController.self))
                    }
                }
            }
        }
    }
}

