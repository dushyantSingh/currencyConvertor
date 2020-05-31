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
    var balance: Double {get}
    var rxBalance: Observable<Double> { get }
    
    @discardableResult
    func addMoney(_ money: Double) -> Bool
    
    func canTake(_ money: Double) -> Bool
    
    @discardableResult
    func takeMoney(_ money: Double) -> Bool
}
class Wallet: WalletType {
    var balance: Double { balanceAvailable.value }
    var currencyCode: String { "SGD" }
    var rxBalance: Observable<Double> { balanceAvailable.asObservable() }
    
    static let shared: Wallet = Wallet()
    private var balanceAvailable: BehaviorRelay<Double>
    
    private init(){
        self.balanceAvailable = BehaviorRelay(value: 10000)
    }
}

extension Wallet {
    func addMoney(_ money: Double) -> Bool {
        let balance = self.balanceAvailable.value
        self.balanceAvailable.accept(balance + money)
        return true
    }
    
    func takeMoney(_ money: Double) -> Bool {
        if balanceAvailable.value < money {
            return false
        }
        let balance = self.balanceAvailable.value
        self.balanceAvailable.accept(balance - money)
        return true
    }
    func canTake(_ money: Double) -> Bool {
        return balanceAvailable.value > money
    }
}
