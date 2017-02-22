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
import TurnstileCrypto
import Newsfeed

class Handler {
    init() { }
    
    func authWith(request: HTTPRequest, response: HTTPResponse?) -> UserModel? {
        guard let token = request.header(.authorization) else {
            return nil
        }
        
        guard let user = UserModel(connect).authWith(token: token) else {
            if let response = response {
                response.setHeader(.contentType, value: "application/json")
                response.status = .unauthorized
                response.completed()
            }
            return nil
        }
        
        return user
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
    func handleGetRegistration(request: HTTPRequest, _ response: HTTPResponse) {
        var user = authWith(request: request, response: nil)
        if user == nil {
            user = UserModel(connect).generateNewUser()
        }
        
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
