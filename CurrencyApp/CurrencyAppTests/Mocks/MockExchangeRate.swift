//
//  MockExchangeRate.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
@testable import CurrencyApp

struct MockExchangeRateFactory {
    static let mockRates = ["SGD": 1.5621,
                            "USD": 1.1016,
                            "EUR": 1.0000,
                            "INR": 83.4635,
                            "IDR": 16210.04,
                            "PHP": 55.792,
                            "SEK": 10.548]

    static let mockExchangeRates = ExchangeModel(rates: mockRates,
                                         base: "EUR",
                                         date: "Today")
}
