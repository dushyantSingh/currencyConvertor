//
//  ConvertorViewModelEvents.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

enum ConvertViewModelEvents {
    case showConvertAlert
    case showErrorAlert(message: String)
}

extension ConvertViewModelEvents {
    static func == (lhs: ConvertViewModelEvents,
                    rhs: ConvertViewModelEvents) -> Bool {
        switch (lhs, rhs) {
        case (.showConvertAlert,
              .showConvertAlert):
            return true
        case (.showErrorAlert(let A),
              .showErrorAlert(let B)):
            return A == B
        default:
            return false
        }
    }
}
