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
//import TurnstileCrypto
import Newsfeed

extension NSError {
    static func message(_ message:String, domain:String = "API.ErrorDomain", code: Int = 500) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString(message, comment:"")])
    }
}

class Handler {
    init() { }
    
    func authWith(request: HTTPRequest, response: HTTPResponse?) -> (UserModel?, NSError?) {
        guard let xWSSE = request.header(.custom(name: "X-WSSE")),
            let authorization = request.header(.custom(name: "Authorization")) else {
            return (nil, NSError.message("Missing token"))
        }
        let wsse = AuthorizationWSSE(xwsse: xWSSE, authorization: authorization)
        guard wsse.isValid else {
            return (nil, NSError.message("Invalid token"))
        }
        guard !wsse.isExpired else {
            return (nil, NSError.message("Expired token"))
        }
        
        guard let user = UserModel(connect).user(username: wsse.userName) else {
            return (nil, NSError.message("Invalid token"))
        }
        
        return (user, nil)
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
        var (user, error) = authWith(request: request, response: nil)
//        if user == nil {
//            user = UserModel(connect).generateNewUser()
//        }
        
        guard let finalUser = user else {
            response.status = .internalServerError
            response.completed()
            return
        }
        
        do {
            try response.setBody(json: successResponse(data: ["token" : finalUser.token]))
        } catch {
            print(error)
        }
        
        response.completed()
    }
    
    func handleGetLogout(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
    }
    
    func handleGetUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        response.sendSuccessReponseWithCurrentPath(request: request)
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

