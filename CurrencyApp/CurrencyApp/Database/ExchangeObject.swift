//
//  ExchangeRateObject.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 1/6/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RealmSwift

class ExchangeObject: Object {
    @objc dynamic var rates: Data = Data()
    @objc dynamic var base: String = ""
    @objc dynamic var date: String = ""
    
    convenience init(exchangeModel: ExchangeModel) {
        self.init()
        let encoder = JSONEncoder()
        if let data  = try? encoder.encode(exchangeModel.rates){
            self.rates = data
        } else {
           print("Rates encoding failed")
        }
        self.base = exchangeModel.base
        self.date = exchangeModel.date
    }
}
