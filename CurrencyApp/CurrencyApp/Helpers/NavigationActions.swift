//
//  NavigationActions.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

enum NavigationAction {
    case push(viewModel: Any, animated: Bool)
    case present(viewModel: Any, animated:Bool)
    case pop(animated: Bool)
    case dismiss(animated: Bool)
}

extension NavigationAction: Equatable {
    static func == (lhs: NavigationAction, rhs: NavigationAction) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push):
            return true
        case (.present, .present):
            return true
        case (.pop, .pop):
            return true
            case (.dismiss, .dismiss):
            return true
        default: return false
        }
    }
}
