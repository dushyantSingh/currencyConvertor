//
//  Wallet.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 1/6/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
protocol WalletType {
    
    var currencyCode:String {get}
    var balance: BehaviorRelay<Double> { get }
    
    func addMoney(_ money: Double) -> Bool
    func takeMoney(_ money: Double) -> Bool
}
class Wallet: WalletType {
    var currencyCode: String { "SGD" }
    
    var balance: BehaviorRelay<Double> { balanceAvailable }
    
    static let shared: Wallet = Wallet()
    private var balanceAvailable: BehaviorRelay<Double>
    
    private init(){
        self.balanceAvailable = BehaviorRelay(value: 10000)
    }
}

extension Wallet {
    func addMoney(_ money: Double) -> Bool {
        let bal = self.balanceAvailable.value
        self.balanceAvailable.accept(bal + money)
        return true
    }
    
    func takeMoney(_ money: Double) -> Bool {
        if balanceAvailable.value < money {
            return false
        }
        let bal = self.balanceAvailable.value
        self.balanceAvailable.accept(bal - money)
        return true
    }
}
