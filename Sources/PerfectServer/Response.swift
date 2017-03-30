//
//  Response.swift
//  Newsfeed
//
//  Created by Raven on 30.03.17.
//
//

import Foundation
import PerfectHTTP
import Authorization

extension HTTPResponse {
    
    func authorization(_ wsse:WSSE) {        
        for header in wsse.headers {
            self.addHeader(.custom(name: header.key), value: header.value)
        }
    }
    
    func stub(_ request: HTTPRequest) {
        var data = [String: String]()
        data["path"] = request.path
        success(data)        
    }
    
    // MARK: Success
    public func prepareSuccess(_ data:Any) {
        var body = [String: Any]()
        body["status"] = "success"
        body["data"] = data
        do {
            try self.setBody(json: body)
        } catch {
            print(error)
        }
        self.completed()
    }
    
    public func success(_ data:Any) {
        prepareSuccess(data)
        self.completed()
    }
    
    // MARK: Fail
    public func prepareFail(_ status: HTTPResponseStatus = .badRequest, messages:[String], code:Int) {
        var body = [String: Any]()
        body["status"] = "error"
        body["statusCode"] = "\(code)"
        body["messages"] = messages
        
        self.status = status
        do {
            try self.setBody(json: body)
        } catch {
            print(error)
        }
    }
    
    public func fail(_ status: HTTPResponseStatus = .badRequest, messages:[String], code:Int) {
        prepareFail(status, messages: messages, code: code)
        self.completed()
    }
    
    public func fail(_ status: HTTPResponseStatus = .badRequest, errors:[Error], code: Int = Error.defaultCode) {
        var messages: [String] = []
        for error in errors {
            messages.append(error.description)
        }
        prepareFail(status, messages: messages, code: errors.count == 1 ? errors.first!.code : code)
        self.completed()
    }
    
    public func fail(_ status: HTTPResponseStatus = .badRequest, error:Error) {
        prepareFail(status, messages: [error.description], code: error.code)
        self.completed()
    }
}

