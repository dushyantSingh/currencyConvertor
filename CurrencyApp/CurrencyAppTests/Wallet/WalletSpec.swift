//
//  WalletSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 1/6/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble


@testable import CurrencyApp

class WalletSpec: QuickSpec {
    override func spec() {
        describe("Wallet Test") {
            let subject = Wallet.shared
            context("when wallet is created") {
                it("should have a balance of 1000 SGD") {
                    expect(subject.balance.value).to(equal(10000))
                }
                it("should have a currency code SGD") {
                    expect(subject.currencyCode).to(equal("SGD"))
                }
            }
        }
    }
}
