//
//  RealmDbType.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

protocol RealmDbType: AnyObject {
    var dbName: String { get }
    var realm: Realm? { get set }
    var schemaVersion: UInt64 { get }
    var objectTypes: [Object.Type] { get }
    
    func initializeDB(completion: (_ success: Bool, _ error: Error?) -> Void)
    func save<T: Object>(object: T)
    func realmObjects<T: Object>(type: T.Type) -> [T]?
    func initializeId() -> Int
}

extension RealmDbType {
    public func initializeDB(completion: (_ success: Bool, _ error: Error?) -> Void) {
        do { let dbURL = getDBURL(name: dbName)
            let config = Realm.Configuration(fileURL: dbURL,
                                             schemaVersion: schemaVersion,
                                             objectTypes: objectTypes)
            self.realm = try Realm(configuration: config)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    public func save<T: Object>(object: T) {
        do {
            try self.realm?.write {
                self.realm?.add(object, update: .modified)
            }
        } catch (let error) {
            fatalError("RealmDB: (\(dbName)), save[T]: \(error.localizedDescription)")
        }
    }

    public func realmObjects<T: Object>(type: T.Type) -> [T]? {
           return self.realm?.objects(T.self).toArray()
    }
}

extension RealmDbType {
    private func getDBURL(name: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url: URL =  URL(fileURLWithPath: documentsPath).appendingPathComponent("Realm")
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
            if !isDir.boolValue {
                createDirectory(url)
            }
        } else {
            createDirectory(url)
        }
        
        let dbURL = url.appendingPathComponent(name)
        return dbURL
    }
    
    private func createDirectory(_ path: URL) {
        do {
            try FileManager.default.createDirectory(at: path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            fatalError("RealmDB: (\(dbName)), init: unable to create a directory at path \(path)")
        }
    }
}
