//
//  Article.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/15/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib

class Article: SQLiteStORM {
    var id = 0
    var title = ""
    var body = ""
    var dateCreated = 0.0
    var dateIndexed = 0.0
    
    // Set the table name
    override open func table() -> String {
        return "article"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        title = this.data["title"] as! String
        body = this.data["body"] as! String
        dateCreated = this.data["date"] as? Double ?? 0.0
        dateIndexed = PerfectLib.getNow()
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
            // INSERT INTO article (title,body,dateCreated,dateIndexed) VALUES ('','','','');
            // CREATE TABLE article(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, body TEXT, dateCreated DATETIME, dateIndexed DATETIME);
            try sqlExec("CREATE TABLE IF NOT EXISTS \(table()) ( " +
                "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
                "title TEXT, " +
                "body TEXT, " +
                "dateCreated DATETIME, " +
                "dateIndexed DATETIME " +
                ")")
        } catch {
            print(error)
        }
    }
}

