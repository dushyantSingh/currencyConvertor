//
//  ExchangeModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

struct ExchangeModel: Codable {
    let rates: [String: Double]
    let base: String
    let date: String
}
