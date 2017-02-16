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

func createTablesIfNeed(connect: SQLiteConnect) {
    UserModel(connect).setup()
    ServiceModel(connect).setup()
    ArticleModel(connect).setup()
    TagModel(connect).setup()
    
    UserTagRelation(connect).setup()
    ArticleTagRelation(connect).setup()
}

