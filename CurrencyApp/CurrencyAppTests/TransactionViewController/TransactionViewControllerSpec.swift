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
                it("should display transaction information for first transaction") {
                    let indexPath1 = IndexPath(row: 0, section: 0)
                    let cell: TransactionTableViewCell = subject
                        .transactionTableView.getCell(indexPath1) as! TransactionTableViewCell
                    let dateString = Date().toString(.tableCell)
                    expect(cell.dateLabel.text).to(equal(dateString))
                    expect(cell.transactionNumberLabel.text).to(equal("CVRT0001"))
                    expect(cell.convertedCurrencyLabel.text).to(equal("SGD 1000.00 to EUR 750.00"))
                    expect(cell.conversionRateLabel.text).to(equal("@ SGD 1 = EUR 0.75"))
                }
                it("should display transaction information for second transaction") {
                    let indexPath1 = IndexPath(row: 1, section: 0)
                    let cell: TransactionTableViewCell = subject
                        .transactionTableView.getCell(indexPath1) as! TransactionTableViewCell
                    let dateString = Date().toString(.tableCell)
                    expect(cell.dateLabel.text).to(equal(dateString))
                    expect(cell.transactionNumberLabel.text).to(equal("CVRT0002"))
                    expect(cell.convertedCurrencyLabel.text).to(equal("SGD 2000.00 to EUR 1500.00"))
                    expect(cell.conversionRateLabel.text).to(equal("@ SGD 1 = EUR 0.75"))
                }
                it("should display transaction information for third transaction") {
                    let indexPath1 = IndexPath(row: 2, section: 0)
                    let cell: TransactionTableViewCell = subject
                        .transactionTableView.getCell(indexPath1) as! TransactionTableViewCell
                    let dateString = Date().toString(.tableCell)
                    expect(cell.dateLabel.text).to(equal(dateString))
                    expect(cell.transactionNumberLabel.text).to(equal("CVRT0003"))
                    expect(cell.convertedCurrencyLabel.text).to(equal("SGD 2000.00 to INR 100000.00"))
                    expect(cell.conversionRateLabel.text).to(equal("@ SGD 1 = INR 50.00"))
                }
            }
        }
    }
}

fileprivate extension UITableView {
    func getCell(_ indexPath: IndexPath) -> UITableViewCell? {
        self.scrollToRow(at: indexPath, at: .top, animated: false)
        return self.cellForRow(at: indexPath)
    }
}

