//
//  User.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/15/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib
import PerfectHTTP
import SwiftyJSON

class User: SQLiteStORM {
    var id = 0
    var hash = ""
    
// MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "user"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        hash = this.data["hash"] as! String
    }
    
    func rows() -> [User] {
        var rows = [User]()
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    // Create the table if needed
    public func setup() {
        do {
            // INSERT INTO user (hash) VALUES ('');
            // CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, hash TEXT);
            try sqlExec("CREATE TABLE IF NOT EXISTS \(table()) (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
                "hash TEXT " +
                ")")
        } catch {
            print(error)
        }
    }
    
// MARK: API
    static func registrationHandler(request: HTTPRequest, _ response: HTTPResponse) {
        var resp = [String: String]()
        resp["path"] = "\(request.path)"
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.setHeader(.contentType, value: "application/json")
        response.completed()
    }
}

