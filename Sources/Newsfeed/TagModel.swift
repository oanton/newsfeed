//
//  TagModel.swift
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

class TagModel: SQLiteStORM {
    var id = 0
    var name = ""
    
    public func removeTagIfNoRelation() {
        do {
            let userRelations = UserTagRelation(self.connection)
            try userRelations.find(["tagID" : self.id])
            if userRelations.rows().count > 0 {
                return
            }
            let articleRelations = ArticleTagRelation(self.connection)
            try articleRelations.find(["tagID" : self.id])
            if articleRelations.rows().count == 0 {
                try self.delete()
            }
        } catch {
            print("There was an error: \(error)")
        }
    }
    
    public func addTag(_ name: String) -> TagModel? {
        do {
            try self.find(["name": name])
            guard self.rows().first != nil else {
                self.name = name
                try self.save(set: { [weak self] (id) in
                    self?.id = id as! Int
                })
                return self
            }
        } catch {
            print("There was an error: \(error)")
            return nil
        }
        return self.rows().first;
    }
    
    // MARK: Tags for User
    // Get all tags by user
    public func allTags(user: UserModel) -> [TagModel] {
        let userTagRelationTableName = UserTagRelation.tableName();
        let joinWithTags = StORMDataSourceJoin(table: userTagRelationTableName, onCondition: "\(userTagRelationTableName).tagID = \(table()).id", direction: .INNER)
        let joinWithUser = StORMDataSourceJoin(table: userTagRelationTableName, onCondition: "\(userTagRelationTableName).userID = \(user.table()).id", direction: .INNER)
        
        do {
            try self.find(["\(user.table()).id":user.id], orderby: ["\(table()).name"], join: [joinWithUser, joinWithTags], groupBy: ["\(table()).name"])
        } catch {
            print("There was an error: \(error)")
            return []
        }
        return self.rows()
    }
    
    // Get tag by User
    public func getTag(_ name: String, user: UserModel) -> TagModel? {
        let userTagRelationTableName = UserTagRelation.tableName();
        let joinWithTags = StORMDataSourceJoin(table: userTagRelationTableName, onCondition: "\(userTagRelationTableName).tagID = \(table()).id", direction: .INNER)
        let joinWithUser = StORMDataSourceJoin(table: userTagRelationTableName, onCondition: "\(userTagRelationTableName).userID = \(user.table()).id", direction: .INNER)
        
        do {
            try self.find(["\(table()).name" : name,"\(user.table()).id":user.id], orderby: ["\(table()).name"], join: [joinWithUser, joinWithTags], groupBy: ["\(table()).name"])
        } catch {
            print("There was an error: \(error)")
            return nil
        }
        return self.rows().first
    }
    
    // Remove tag by User
    public func removeTag(user: UserModel) {
        let tagRelations = UserTagRelation(user.connection)
        do {
            try tagRelations.find(["userID" : user.id])
            for relation in tagRelations.rows() {
                try relation.delete()
            }
        } catch {
            print("There was an error: \(error)")
        }
        
        self.removeTagIfNoRelation()
    }
    
    // Add tag by User
    public func addTag(_ name: String, user: UserModel) {
        let tag = addTag(name)
        guard tag != nil else {
            return
        }
        let relations = UserTagRelation(user.connection)
        do {
            try relations.find(["userID":user.id,"tagID":tag!.id])
            guard relations.rows().first != nil else {
                relations.userID = user.id
                relations.tagID = tag!.id
                try relations.save()
                return
            }
        } catch {
            print("There was an error: \(error)")
            return
        }
    }

    // MARK: Tags for Article
    
    
    // MARK: DataBase
    // Set the table name
    override open func table() -> String {
        return "tag"
    }
    
    // Need to do this because of the nature of Swift's introspection
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as! String
    }
    
    func rows() -> [TagModel] {
        var rows = [TagModel]()
        for i in 0..<self.results.rows.count {
            let row = TagModel()
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
