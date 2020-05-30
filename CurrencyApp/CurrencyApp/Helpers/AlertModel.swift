//
//  AlertViewHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

struct AlertModel {
    let title: String
    let style: UIAlertAction.Style
}
enum AlertModelEvent {
    case alertButtonTapped(buttonIndex: Int)
}
extension AlertModelEvent: Equatable {
    static func == (lhs: AlertModelEvent, rhs: AlertModelEvent) -> Bool {
        switch (lhs, rhs) {
        case (.alertButtonTapped(let A), alertButtonTapped(let B)):
            return A == B
        }
    }
}
