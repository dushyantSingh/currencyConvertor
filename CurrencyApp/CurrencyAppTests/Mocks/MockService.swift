//
//  MockService.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift

@testable import CurrencyApp

class MockCurrencyService: CurrencyServiceType {
    var isRetrieveCalled = false
    let onRetrieve = PublishSubject<ExchangeModel>()
    func retrieve<T>(request: URLRequest) -> Observable<T> {
        isRetrieveCalled = true
        return self.onRetrieve.asObservable() as! Observable<T>
    }
}
