//
//  TransactionDb.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionDb: RealmDbType {
    var dbName: String { "TransactionDB" }
    var schemaVersion: UInt64 { 1 }
    var objectTypes: [Object.Type] {[TransactionObject.self,
                                     ExchangeObject.self]}
    var realm: Realm?
     
    static let shared: TransactionDb = TransactionDb()
    private init() {
        self.initializeDB { success, _ in
            if !success {
                print("TransactionDb failed to initialize")
            }
        }
    }
}

extension TransactionDb {
    func initializeId() -> Int {
        return (self.realmObjects(type: TransactionObject.self)?.map{$0.id}.max() ?? 0) + 1
    }
}
