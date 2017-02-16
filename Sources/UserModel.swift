//
//  UserModel.swift
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

import PerfectSession
import TurnstileCrypto

class UserModel: SQLiteStORM {
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
    
    func rows() -> [UserModel] {
        var rows = [UserModel]()
        for i in 0..<self.results.rows.count {
            let row = UserModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    // Create the table if needed
    public func setup() {
        do {
            try self.setupTable()
        } catch {
            print(error)
        }
    }
    
    // MARK: API
    static func logoutHandler(request: HTTPRequest, _ response: HTTPResponse) {
        var data = [String: String]()
        data["path"] = "\(request.path)"
        do {
            try response.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        jsonResponse(response)
        response.completed()
    }
    
    static func registrationHandler(request: HTTPRequest, _ response: HTTPResponse) {
        
        jsonResponse(response)
        var session = request.session
        if session == nil {
            session = PerfectSession()
            let rand = URandom()
            session?.token = rand.secureToken
        }
        
        request.session = session
        var data = [String: String]()
        data["token"] = session?.token ?? ""
        do {
            try response.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        
        response.completed()
    }
    
    static func tagsHandler(request: HTTPRequest, _ response: HTTPResponse) {
        var data = [String: String]()
        data["path"] = "\(request.path)"
        do {
            try response.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        jsonResponse(response)
        response.completed()
    }
    
    static func addTagHandler(request: HTTPRequest, _ response: HTTPResponse) {
        var data = [String: String]()
        data["path"] = "\(request.path)"
        do {
            try response.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        jsonResponse(response)
        response.completed()
    }
    
    static func deleteTagHandler(request: HTTPRequest, _ response: HTTPResponse) {
        var data = [String: String]()
        data["path"] = "\(request.path)"
        do {
            try response.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        jsonResponse(response)
        response.completed()
    }    
}

