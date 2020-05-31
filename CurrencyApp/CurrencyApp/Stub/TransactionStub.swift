//
//  Transactions.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

struct TransactionStub {
    static let transaction1: TransactionModel = TransactionModel(transactionId: "CVRT0001",
                                                                 transactionDate: Date(),
                                                                 fromCurrencyCode: "SGD",
                                                                 fromCurrency: 1000.00,
                                                                 toCurrencyCode: "EUR",
                                                                 toCurrency: 750,
                                                                 exchangeRate: 0.75)
    static let transaction2: TransactionModel = TransactionModel(transactionId: "CVRT0002",
                                                                 transactionDate: Date(),
                                                                 fromCurrencyCode: "SGD",
                                                                 fromCurrency: 2000.00,
                                                                 toCurrencyCode: "EUR",
                                                                 toCurrency: 1500,
                                                                 exchangeRate: 0.75)
    static let transaction3: TransactionModel = TransactionModel(transactionId: "CVRT0003",
                                                                 transactionDate: Date(),
                                                                 fromCurrencyCode: "SGD",
                                                                 fromCurrency: 2000.00,
                                                                 toCurrencyCode: "INR",
                                                                 toCurrency: 100000,
                                                                 exchangeRate: 50)
    static let transaction4: TransactionModel = TransactionModel(transactionId: "CVRT0004",
                                                                 transactionDate: Date(),
                                                                 fromCurrencyCode: "SGD",
                                                                 fromCurrency: 2000.00,
                                                                 toCurrencyCode: "USD",
                                                                 toCurrency: 1660,
                                                                 exchangeRate: 0.83)
    
    static let transactions: [TransactionModel] = [transaction1,
                                                   transaction2,
                                                   transaction3,
                                                   transaction4]
}
