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

import COpenSSL

extension String.UTF8View {
    var sha1: [UInt8] {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity:  Int(SHA_DIGEST_LENGTH))
        defer { bytes.deallocate(capacity: Int(SHA_DIGEST_LENGTH)) }
        
        SHA1(Array<UInt8>(self), (self.count), bytes)
        
        var r = [UInt8]()
        for idx in 0..<Int(SHA_DIGEST_LENGTH) {
            r.append(bytes[idx])
        }
        return r
    }
}

extension UInt8 {
    // same as String(self, radix: 16)
    // but outputs two characters. i.e. 0 padded
    var hexString: String {
        let s = String(self, radix: 16)
        if s.characters.count == 1 {
            return "0" + s
        }
        return s
    }
}

class WSSE {
    
    enum HeaderKey : String {
        case username = "Username"
        case passwordDigest = "PasswordDigest"
        case nonce = "Nonce"
        case created = "Created"
    }
    
    var userName = ""
    var digestEncoded = ""
    var nonce = ""
    var created = ""
    
    init(user:String, secret:String) {
        userName = user
        nonce = UUID().uuidString
        created = String(Date().timeIntervalSince1970)
        let digest = "\(nonce)\(created)\(secret)".utf8.sha1
        digestEncoded = digest.map { $0.hexString }.joined(separator: "")
    }
    
    init(_ header: String) {
        var results = [String:String]()
        let keys = header.components(separatedBy:", ")
        for pair in keys {
            let kv = pair.components(separatedBy:"=")
            if kv.count > 1 {
                results.updateValue(kv[1], forKey: kv[0])
            }
        }
//        guard let user = results[HeaderKey.username] else {
//            userName = user ? : ""
//        }
//        userName = results[HeaderKey.username] as? String
//        digestEncoded = results[HeaderKey.passwordDigest] as? String
//        nonce = results[HeaderKey.nonce] as? String
//        created = results[HeaderKey.created] as? String
//
    }
    
    var header : String {
        return "UsernameToken \(HeaderKey.username)=\"\(userName)\", \(HeaderKey.passwordDigest)=\"\(digestEncoded)\", \(HeaderKey.nonce)=\"\(nonce.toBase64())\", \(HeaderKey.created)=\"\(created)\""
    }
    
}

class Handler {
    init() { }
    
    func authWith(request: HTTPRequest, response: HTTPResponse?) -> UserModel? {
        guard let token = request.header(.custom(name: "X-WSSE")) else {
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


//MARK: options
extension Handler {
    func handleOptions(request: HTTPRequest, _ response: HTTPResponse) {
        response.completed()
    }
}

