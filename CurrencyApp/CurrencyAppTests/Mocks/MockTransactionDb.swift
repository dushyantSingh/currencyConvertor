//
//  MockTransactionDb.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 1/6/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RealmSwift

@testable import CurrencyApp

class MockTransactionDb: RealmDbType {
    var dbName: String = "Mock"
    var realm: Realm?
    var schemaVersion: UInt64 = 1
    var objectTypes: [Object.Type] = [TransactionObject.self]
    
    var saveTransactionCalledWithObject: Object?
    var saveWithoutUpdateCalledWithObject: Object?
    var fetchTransactionsCalled: Bool = false
    func initializeId() -> Int {
        return 101
    }
    func save<T>(object: T) where T : Object {
        saveTransactionCalledWithObject = object
    }
    func realmObjects<T>(type: T.Type) -> [T]? where T : Object {
        fetchTransactionsCalled = true
        return []
    }
    func saveWithoutUpdate<T>(objects: [T]) where T : Object {
        saveWithoutUpdateCalledWithObject = objects.first
    }
}
