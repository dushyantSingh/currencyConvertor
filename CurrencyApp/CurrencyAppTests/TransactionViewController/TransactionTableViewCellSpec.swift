//
//  TransactionTableViewCellSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble

@testable import CurrencyApp

class TransactionTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("TransactionTableViewCell Test") {
            var subject: TransactionTableViewCell!
            beforeEach {
                let nibName = "\(TransactionTableViewCell.self)"
                let nib = UINib(nibName: nibName,
                                bundle: Bundle(for: TransactionTableViewCell.self))
                let nibViews = nib.instantiate(withOwner: nil, options: nil)

                guard let nibView = nibViews[0] as? TransactionTableViewCell else {
                    fail("Unable to create view from nib \(nibName)")
                    return
                }
                subject = nibView
            }
            context("when cell configured with 0001") {
                var cellModel: TransactionCellModel!
                beforeEach {
                    cellModel = TransactionCellModel(idString: "0001",
                                                     dateString: "Today",
                                                     exchangeString:"Exchange value",
                                                     exchangeRateString: "Exchange Rate")
                    subject.configure(with: cellModel)
                }
                it("should display all values") {
                    expect(subject.transactionNumberLabel.text).to(equal("0001"))
                    expect(subject.dateLabel.text).to(equal("Today"))
                    expect(subject.convertedCurrencyLabel.text).to(equal("Exchange value"))
                    expect(subject.conversionRateLabel.text).to(equal("Exchange Rate"))
                }
            }
            context("when cell configured with 0002") {
                var cellModel: TransactionCellModel!
                beforeEach {
                    cellModel = TransactionCellModel(idString: "0002",
                                                     dateString: "Date of something",
                                                     exchangeString:"Exchange value for 100 SGD",
                                                     exchangeRateString: "Exchange Rate for 1 SGD")
                    subject.configure(with: cellModel)
                }
                it("should display all values") {
                    expect(subject.transactionNumberLabel.text).to(equal("0002"))
                    expect(subject.dateLabel.text).to(equal("Date of something"))
                    expect(subject.convertedCurrencyLabel.text).to(equal("Exchange value for 100 SGD"))
                    expect(subject.conversionRateLabel.text).to(equal("Exchange Rate for 1 SGD"))
                }
            }
        }
    }
}
