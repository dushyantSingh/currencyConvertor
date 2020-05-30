//
//  CurrencyRequest.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

enum RequestType: String {
    case GET, POST, PUT,DELETE
}
struct CurrencyRequest {
    static func exchangeRequest(baseURL: URL) -> URLRequest {
        let url = baseURL.appendingPathComponent("latest")
        var  request = URLRequest(url:url)
        request.httpMethod = RequestType.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
