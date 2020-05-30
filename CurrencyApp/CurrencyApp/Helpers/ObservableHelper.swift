//
//  ObservableHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift

extension Observable where Element == (String, String, String, [String: Double]) {
    func calculateExchangeToCurrency() -> Observable<String> {
        return map { value1, value2, value3, rates -> (Double?, Double?, Double?) in
            return (Double(value1), rates[value2], rates[value3]) }
            .map { value1, value2, value3 in
                guard let value1 = value1,
                    let value2 = value2,
                    let value3 = value3 else { return "" }
                return String(format:"%.2f", (value1/value2) * value3) }
    }
}
