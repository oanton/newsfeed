//
//  UserModel.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/15/17.
//
//

import Foundation
import StORM
import SQLiteStORM
import PerfectLib
import PerfectHTTP
import SwiftyJSON

import PerfectSession
import TurnstileCrypto

public class UserModel: SQLiteStORM {
    public var id: Int = 0
    public var token: String = ""
    
    public func generateNewUser() -> UserModel? {
        self.token = Data(UUID().uuidString.utf8).base64EncodedString()
        
        do {
            try self.save(set: { [weak self] (id) in
                self?.id = id as! Int
            })
        } catch {
            print("Can't create user. Error: \(error)")
            return nil
        }
        
        return self
    }
    
    public func authWith(token: String) -> UserModel? {
        do {
            try self.find([("token", token)])
        } catch {
            print("Error occured during user finding. Error: \(error)")
            return nil
        }
        
        if self.id == 0 {
            return nil
        }
        
        return self
    }
    
    func allTags() -> [TagModel] {
        return TagModel(connection).allTags(user: self)
    }
    
    func addTag(tag:String) {
        TagModel(connection).addTag(tag, user: self)
    }
    
    func removeTag(tag:TagModel) {
        TagModel(connection).removeTag(user: self)
    }
    
    
    // MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "user"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        token = this.data["token"] as! String
    }
    
    public func rows() -> [UserModel] {
        var rows = [UserModel]()
        for i in 0..<self.results.rows.count {
            let row = UserModel()
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

