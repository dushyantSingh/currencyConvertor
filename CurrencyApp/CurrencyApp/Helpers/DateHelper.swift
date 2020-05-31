//
//  DateHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

enum DateFormat {
    case long
    case tableCell
}
extension Date {
    func toString(_ format: DateFormat = .long) -> String {
        let dateFormatter = DateFormatter()
        switch format {
        case .long:
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        case .tableCell:
            let calendar = Calendar.current
            if calendar.isDateInToday(self) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" }
        }
        return dateFormatter.string(from: self)
    }
}
