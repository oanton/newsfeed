//
//  UserTagRelation.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/16/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib
import PerfectHTTP
import SwiftyJSON

class UserTagRelation: SQLiteStORM {
    var userID = 0
    var tagID = 0
    
    // MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "user_tag_relation"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        userID = this.data["userID"] as? Int ?? 0
        tagID = this.data["tagID"] as? Int ?? 0
    }
    
    func rows() -> [UserTagRelation] {
        var rows = [UserTagRelation]()
        for i in 0..<self.results.rows.count {
            let row = UserTagRelation()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    // Create the table if needed
    public override func setupTable() {
        do {
            try super.setupTable()
        } catch {
            print(error)
        }
    }
}
