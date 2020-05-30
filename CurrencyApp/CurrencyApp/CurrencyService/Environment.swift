//
//  Environment.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
class Enviornment {
    static let manager = Enviornment()
    
    var baseURL: URL {
        return URL(string: "https://api.exchangeratesapi.io/")!
    }
}
