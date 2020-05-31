//
//  MockWallet.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 1/6/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
@testable import CurrencyApp

class MockWallet: WalletType {
    var currencyCode: String { "SGD"}
    var balance: BehaviorRelay<Double> { mockBalance }
    
    var takeMoneyCalled = false
    var mockBalance = BehaviorRelay<Double>(value: 1000)
    func addMoney(_ money: Double) -> Bool {
        return true
    }
    func takeMoney(_ money: Double) -> Bool {
        takeMoneyCalled = true
        return true
    }
    func canTake(_ money: Double) -> Bool {
        return true
    }
}
