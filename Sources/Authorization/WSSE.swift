//
//  Authorization.swift
//  Newsfeed
//
//  Created by MiniOS on 23.03.17.
//
//

import Foundation
import SwiftString

struct HeaderWSSE {
    static let Username = "Username"
    static let Digest = "PasswordDigest"
    static let Nonce = "Nonce"
    static let Created = "Created"
    static let Profile = "profile"
}

public class WSSE : Authorization {
    
    public private(set) var profile = "UsernameToken"
    public private(set) var userName = ""
    public private(set) var digestEncoded = ""
    public private(set) var nonce = ""
    public private(set) var created = ""
    public private(set) var maxAge : Double = 3600
    
    @available(*, unavailable, message: "init is unavailable")
    override init() {
        fatalError()
    }
    
    public init(user:String, secret:String) {
        super.init()
        userName = user
        nonce = UUID().uuidString
        created = String(Date().timeIntervalSince1970)
        digestEncoded = self.encoded(nonce: nonce, created: created, secret: secret)
    }
    
    public init(xwsse: String, authorization: String) {
        super.init()
        let pattern = "\\s([a-zA-Z]+)=\"([^\"]+)\""
        let headers = self.parse(body: xwsse, pattern: pattern)
        guard headers.count == 4 else {
            return
        }
        self.userName = headers[HeaderWSSE.Username]!
        guard let digest = headers[HeaderWSSE.Digest]!.fromBase64() else {
            return
        }
        guard let nonce = headers[HeaderWSSE.Nonce]!.fromBase64() else {
            return
        }
        self.digestEncoded = digest
        self.nonce = nonce
        self.created = headers[HeaderWSSE.Created]!
        
        let profiles = self.parse(body: authorization, pattern: pattern)
        if profiles.count > 0 {
            profile = profiles[HeaderWSSE.Profile]!
        }
    }
    
    private func encoded(nonce:String, created:String, secret:String) -> String {
        return Encryption.sha1("\(nonce)\(created)\(secret)")
    }
    
    private func parse(body:String, pattern:String) -> [String:String] {
        let regex = try! NSRegularExpression(pattern: pattern,
                                             options: .caseInsensitive)
        let matches = regex.matches(in: body,
                                    range: NSMakeRange(0, body.utf16.count))
        
        var values : [String:String] = [:]
        
        for result in matches {
            let keyRange = result.rangeAt(1)
            let valueRange = result.rangeAt(2)
            let key = body.substring(keyRange.location, length: keyRange.length)
            let value = body.substring(valueRange.location, length: valueRange.length)
            values.updateValue(value, forKey: key)
        }
        return values
    }
    
    public func validatePassword(secret:String) -> Bool {
        return digestEncoded == self.encoded(nonce: nonce, created: created, secret: secret)
    }
    
    public var isExpired : Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        guard let createdDate = dateFormatter.date(from: created) else {
            return false
        }
        let timeLeft = Date().timeIntervalSince1970 - createdDate.timeIntervalSince1970
        return !(timeLeft >= 0 && timeLeft <= maxAge)
    }
    
    public var isValid : Bool {
        return !(profile.isEmpty || userName.isEmpty || digestEncoded.isEmpty || nonce.isEmpty || created.isEmpty)
    }
    
    public var authorization : String {
        return "WSSE \(HeaderWSSE.Profile)=\"\(profile)\""
    }
    
    public var wsse : String {
        return "\(profile) \(HeaderWSSE.Username)=\"\(userName)\", \(HeaderWSSE.Digest)=\"\(digestEncoded.toBase64())\", \(HeaderWSSE.Nonce)=\"\(nonce.toBase64())\", \(HeaderWSSE.Created)=\"\(created)\""
    }
    
}
