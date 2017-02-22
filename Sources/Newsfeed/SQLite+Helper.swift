//
//  SQLite+Helper.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/15/17.
//
//

import PerfectLib
import StORM
import SQLiteStORM

extension SQLiteConnect {
    public func createTablesIfNeeded() {
        UserModel(self).setupTable()
        ServiceModel(self).setupTable()
        ArticleModel(self).setupTable()
        TagModel(self).setupTable()
        
        UserTagRelation(self).setupTable()
        ArticleTagRelation(self).setupTable()
    }
}

