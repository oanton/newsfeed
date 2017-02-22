//
//  ArticleModel.swift
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

class ArticleModel: SQLiteStORM {
    var id = 0
    var title = ""
    var description = ""
    var url = ""
    var dateCreated = 0.0
    var dateIndexed = 0.0
    var serverID = 0
    var isRead = 0
    
    // MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "article"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        serverID = this.data["serverID"] as? Int ?? 0
        isRead = this.data["isRead"] as? Int ?? 0
        title = this.data["title"] as! String
        url = this.data["url"] as! String
        description = this.data["description"] as! String
        dateCreated = this.data["date"] as? Double ?? 0.0
        dateIndexed = PerfectLib.getNow()
    }
    
    func rows() -> [ArticleModel] {
        var rows = [ArticleModel]()
        for i in 0..<self.results.rows.count {
            let row = ArticleModel()
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

