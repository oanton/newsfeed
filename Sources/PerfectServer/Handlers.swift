//
//  Handlers.swift
//  Newsfeed
//
//  Created by Anton on 20.02.17.
//
//

import Foundation
import PerfectHTTP
import PerfectSession
import Newsfeed
import Authorization

extension NSError {
    static func message(_ message:String, domain:String = "API.ErrorDomain", code: Int = 500) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString(message, comment:"")])
    }
}

class Handler {
    init() { }
    
    func serverError(_ response: HTTPResponse, error: NSError) {
        response.status = .badRequest
        do {
            try response.setBody(json: failResponse(messages: [error.localizedDescription], code: error.code))
        } catch {
            print(error)
        }
        response.completed()
    }
    
    func authWith(request: HTTPRequest, response: HTTPResponse) -> UserModel? {
        let invalidTokenError = NSError.message("Invalid token")
        
        guard let xWSSE = request.header(.custom(name: "X-WSSE")),
            let authorization = request.header(.custom(name: "Authorization")) else {
                self.serverError(response, error: NSError.message("Missing token"))
                return nil
        }
        
        let wsse = WSSE(xwsse: xWSSE, authorization: authorization)
        guard wsse.isValid else {
            self.serverError(response, error: invalidTokenError)
            return nil
        }
        
        guard !wsse.isExpired else {
            self.serverError(response, error: NSError.message("Expired token"))
            return nil
        }
        
        guard let user = UserModel(connect).user(username: wsse.userName) else {
            self.serverError(response, error: invalidTokenError)
            return nil
        }
        
        if wsse.validatePassword(secret: user.salt) {
            return user
        }
        
        self.serverError(response, error: invalidTokenError)
        return nil
    }
    
}

//MARK: services
extension Handler {
    func handleGetServices(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
}

//MARK: users
extension Handler {
    func handlePostRegistration(request: HTTPRequest, _ response: HTTPResponse) {
    }
    
    func handleGetLogout(request: HTTPRequest, _ response: HTTPResponse) {
        if authWith(request: request, response: response) != nil {
            response.sendSuccessReponseWithCurrentPath(request: request)
            response.completed()
        }
    }
    
    func handleGetUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        if let user = authWith(request: request, response: response) {
            response.sendSuccessReponseWithCurrentPath(request: request)
            response.completed()
        }
    }
    
    func handlePostUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }

    func handleDeleteUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
}

//MARK: articles
extension Handler {
    func handleGetArticles(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
    
    func handleGetArticleMarkAsRead(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
    
    func handleGetArticleMarkAsUnread(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
}


//MARK: options
extension Handler {
    func handleOptions(request: HTTPRequest, _ response: HTTPResponse) {
        response.completed()
    }
}

