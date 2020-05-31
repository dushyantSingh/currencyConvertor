//
//  TransactionObject.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionObject: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic public var transactionId: String = ""
    @objc dynamic public var transactionDate: Date = Date()
    @objc dynamic public var fromCurrencyCode: String = ""
    @objc dynamic public var fromCurrency: Double = 0.00
    @objc dynamic public var toCurrencyCode: String = ""
    @objc dynamic public var toCurrency: Double = 0.00
    @objc dynamic public var exchangeRate: Double = 0.00
    

    convenience init(transactionModel: TransactionModel) {
        self.init()
        self.id = transactionModel.id
        self.transactionId = transactionModel.transactionId
        self.transactionDate = transactionModel.transactionDate
        self.fromCurrency = transactionModel.fromCurrency
        self.fromCurrencyCode = transactionModel.fromCurrencyCode
        self.toCurrencyCode = transactionModel.toCurrencyCode
        self.toCurrency = transactionModel.toCurrency
        self.exchangeRate = transactionModel.exchangeRate
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
