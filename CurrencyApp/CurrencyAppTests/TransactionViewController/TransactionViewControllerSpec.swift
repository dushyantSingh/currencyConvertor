//
//  TransactionViewController.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class TransactionViewControllerSpec: QuickSpec {
    override func spec() {
        describe("TransactionViewController Test") {
            var subject: TransactionViewController!
            var viewModel: TransactionViewModel!
            beforeEach {
                let stub = TransactionStub.transactions
                viewModel = TransactionViewModel(transactions: stub)
                subject = UIViewController.make(viewController: TransactionViewController.self)
                subject.viewModel = viewModel
                _ = subject.view
            }
            context("when view loads") {
                it("should display title"){
                    expect(subject.title).to(equal("Transactions"))
                }
                it("should display 4 transactions"){
                    expect(subject.transactionTableView.numberOfRows(inSection: 0))
                        .to(equal(4))
                }
            }
        }
    }
}
