//
//  ConvertorViewModelEvents.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

enum ConvertorViewModelEvents {
    case showConvertAlert(message: String)
    case showErrorAlert(message: String)
    case showTransactionView
}

extension ConvertorViewModelEvents {
    static func == (lhs: ConvertorViewModelEvents,
                    rhs: ConvertorViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.showConvertAlert(let A),
              .showConvertAlert(let B)):
            return A == B
        case (.showErrorAlert(let A),
              .showErrorAlert(let B)):
            return A == B
        default:
            return false
        }
    }
}
