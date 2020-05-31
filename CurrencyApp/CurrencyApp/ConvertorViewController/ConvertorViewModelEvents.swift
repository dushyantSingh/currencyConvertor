//
//  ConvertorViewModelEvents.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

enum ConvertViewModelEvents {
    case showConvertAlert(message: String)
    case showErrorAlert(message: String)
    case showTransactionView
}

extension ConvertViewModelEvents {
    static func == (lhs: ConvertViewModelEvents,
                    rhs: ConvertViewModelEvents) -> Bool {
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
