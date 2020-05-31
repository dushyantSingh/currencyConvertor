//
//  TransactionModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

struct TransactionModel {
    let id: Int
    let transactionId: String
    let transactionDate: Date
    let fromCurrencyCode: String
    let fromCurrency: Double
    let toCurrencyCode: String
    let toCurrency: Double
    let exchangeRate: Double
    
    init(id: Int,
         transactionId: String,
         transactionDate: Date,
         fromCurrencyCode: String,
         fromCurrency: Double,
         toCurrencyCode: String,
         toCurrency: Double,
         exchangeRate: Double) {
        self.id = id
        self.transactionId = transactionId
        self.transactionDate = transactionDate
        self.fromCurrency = fromCurrency
        self.fromCurrencyCode = fromCurrencyCode
        self.toCurrencyCode = toCurrencyCode
        self.toCurrency = toCurrency
        self.exchangeRate = exchangeRate
    }
    init(transactionObject: TransactionObject) {
        self.id = transactionObject.id
        self.transactionId = transactionObject.transactionId
        self.transactionDate = transactionObject.transactionDate
        self.fromCurrency = transactionObject.fromCurrency
        self.fromCurrencyCode = transactionObject.fromCurrencyCode
        self.toCurrencyCode = transactionObject.toCurrencyCode
        self.toCurrency = transactionObject.toCurrency
        self.exchangeRate = transactionObject.exchangeRate
    }
}
