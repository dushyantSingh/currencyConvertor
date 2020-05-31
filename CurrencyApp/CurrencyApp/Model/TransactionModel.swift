//
//  TransactionModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

struct TransactionModel {
    let transactionId: String
    let transactionDate: Date
    let fromCurrencyCode: String
    let fromCurrency: Double
    let toCurrencyCode: String
    let toCurrency: Double
    let exchangeRate: Double
}
