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

class Handler {
    init() { }

    func authWith(request: HTTPRequest, response: HTTPResponse) -> UserModel? {
        
        guard let xWSSE = request.header(.custom(name: "X-WSSE")),
            let authorization = request.header(.custom(name: "Authorization")) else {
                response.fail(.unauthorized, errors: [.missingToken])
                return nil
        }
        
        let wsse = WSSE(xwsse: xWSSE, authorization: authorization)
        guard wsse.isValid else {
            response.fail(.unauthorized, errors: [.invalidToken])
            return nil
        }
        
        guard !wsse.isExpired else {
            response.fail(.unauthorized, errors: [.expiredToken])
            return nil
        }
        
        guard let user = UserModel(connect).user(username: wsse.userName) else {
            response.fail(.unauthorized, errors: [.invalidToken])
            return nil
        }
        
        if wsse.validatePassword(secret: user.salt) {
            user.session = wsse
            return user
        }
        
        response.fail(.unauthorized, errors: [.invalidToken])
        return nil
    }
    
}

//MARK: services
extension Handler {
    func handleGetServices(request: HTTPRequest, _ response: HTTPResponse) {
        response.stub(request)
    }
}

//MARK: users
extension Handler {
    func handlePostRegistration(request: HTTPRequest, _ response: HTTPResponse) {
        
        guard let params = request.jsonBody as? [String:String] else {
            response.fail(error: Error.incorrectFormat)
            return
        }
        
        // validation params
        guard let email = params["username"] else {
            response.fail(error: Error.requiredField(name: "username"))
            return
        }
        
        guard let password = params["password"] else {
            response.fail(error: Error.requiredField(name: "password"))
            return
        }
        
        // TODO: need add validation email
        
        guard UserModel(connect).user(username: email) == nil else {
            response.fail(error: Error.custom(name: "User already exists", code: Error.defaultCode))
            return
        }
        
        let user = UserModel(connect).create(username: email, password: password)
        user.session = WSSE(user: user.email, secret: user.password)
        do {
            try user.save()
        } catch {
            print("can't save user")
        }
        response.authorization(user.session!)
        response.success(["token" : user.token])
    }
    
    func handleGetLogout(request: HTTPRequest, _ response: HTTPResponse) {
        response.stub(request)
    }
    
    func handleGetUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        if let user = authWith(request: request, response: response) {
            response.authorization(user.session!)
            var tags = [Any]()
            for tag in user.allTags() {
                tags.append(tag.description)
            }
            response.success(["tags":tags])
        }
    }
    
    func handlePostUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        if let user = authWith(request: request, response: response) {
            response.authorization(user.session!)
            
            guard let params = request.jsonBody as? [String:String] else {
                response.fail(error: Error.incorrectFormat)
                return
            }
            
            guard let tagName = params["tag"] else {
                response.fail(error: Error.requiredField(name: "tag"))
                return
            }
            
            guard let tag = user.addTag(tag: tagName) else {
                response.fail(error: Error.custom(name: "Can't to add tag to user", code: Error.defaultCode))
                return
            }
            
            response.success(["tag":tag])
        }
    }

    func handleDeleteUsersTags(request: HTTPRequest, _ response: HTTPResponse) {
        if let user = authWith(request: request, response: response) {
            response.authorization(user.session!)
            response.success(["tag"])
        }
    }
}

//MARK: articles
extension Handler {
    func handleGetArticles(request: HTTPRequest, _ response: HTTPResponse) {
        response.stub(request)
    }
    
    func handleGetArticleMarkAsRead(request: HTTPRequest, _ response: HTTPResponse) {
        response.stub(request)
    }
    
    func handleGetArticleMarkAsUnread(request: HTTPRequest, _ response: HTTPResponse) {
        response.stub(request)
    }
}


//MARK: options
extension Handler {
    func handleOptions(request: HTTPRequest, _ response: HTTPResponse) {
        response.completed()
    }
}

