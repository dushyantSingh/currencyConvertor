//
//   CurrencyService.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
protocol CurrencyServiceType {
    func retrieve<T: Codable>(request: URLRequest) -> Observable<T>
}

class CurrencyService: CurrencyServiceType {
    func retrieve<T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable.create { observe in
            let task = URLSession.shared
                .dataTask(with: request) { data, response, error in
                    if let error = error {
                        return observe.onError(error)
                    }
                    do {
                        let responseModel: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                        observe.onNext(responseModel)
                    } catch let error {
                        observe.onError(error)
                    }
                    observe.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
