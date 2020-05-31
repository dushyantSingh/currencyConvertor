//
//  ModelConvertor.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

struct ModelConvertor {
    static func convertToCellModel(_ transactionModel: TransactionModel) -> TransactionCellModel {
        let dateString = transactionModel.transactionDate.toString(.tableCell)
        let fromCurrencyString = String(format:"%.2f", transactionModel.fromCurrency)
        let toCurrencyString = String(format:"%.2f", transactionModel.toCurrency)
        let exchangeRate = String(format:"%.2f", transactionModel.exchangeRate)
        
        let exchangeString = "\(transactionModel.fromCurrencyCode) \(fromCurrencyString) to \(transactionModel.toCurrencyCode) \(toCurrencyString)"
        
        let exchangeRateString = "@ \(transactionModel.fromCurrencyCode) 1 = \(transactionModel.toCurrencyCode) \(exchangeRate)"
        
        return TransactionCellModel(idString: transactionModel.transactionId,
            dateString: dateString,
            exchangeString: exchangeString,
            exchangeRateString: exchangeRateString)
    }
}
