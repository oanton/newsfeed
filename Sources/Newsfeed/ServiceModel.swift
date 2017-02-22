//
//  ServiceModel.swift
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

class ServiceModel: SQLiteStORM {
    var id = 0
    var name = ""
    var host = ""
    
    // MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "service"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as! String
        host = this.data["host"] as! String
    }
    
    func rows() -> [ServiceModel] {
        var rows = [ServiceModel]()
        for i in 0..<self.results.rows.count {
            let row = ServiceModel()
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
