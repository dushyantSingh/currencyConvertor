//
//  MainViewModelCoordinator.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class MainViewModelCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("MainViewModelCoordinator Test") {
            var subject: MainViewModelCoordinator!
            var mockDb: MockTransactionDb!
            var disposeBag: DisposeBag!
            beforeEach {
                mockDb = MockTransactionDb()
                subject = MainViewModelCoordinator(transactionDb: mockDb)
                disposeBag = DisposeBag()
            }
            context("when create convertor view model") {
                var viewModel: ConvertorViewModel!
                beforeEach {
                    viewModel = subject.createStartUpViewModel()
                }
                context("when show transaction view event is triggered") {
                    var navigationAction: NavigationAction!
                    beforeEach {
                        subject.navigationAction
                            .subscribe(onNext:{
                                navigationAction = $0
                            })
                            .disposed(by: disposeBag)
                        viewModel.events
                            .onNext(.showTransactionView)
                    }
                    it("should fetch transactions from db") {
                        expect(mockDb.fetchTransactionsCalled).to(beTrue())
                    }
                    it("should push edit note view controller") {
                        expect(navigationAction).to(equal(.push(viewModel: "Any", animated: true)))
                    }
                }
            }
        }
    }
}
