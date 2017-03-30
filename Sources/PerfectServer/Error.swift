//
//  Errors.swift
//  Newsfeed
//
//  Created by MiniOS on 30.03.17.
//
//

import Foundation

public enum Error {
    case invalidToken, expiredToken, missingToken
    case incorrectFormat
    case requiredField(name: String)
    case custom(name: String, code:Int)
    
    public var description: String {
        switch self {
        case .invalidToken: return "Invalid Token"
        case .expiredToken: return "Expired Token"
        case .missingToken: return "Missing Token"
        case .incorrectFormat: return "Incorrect JSON Format"
        case .requiredField(let name): return "\(name) is required field"
        case .custom(let name, _): return name
        }
    }
    
    public var code: Int {
        switch self {
        case .invalidToken: return 1001
        case .expiredToken: return 1002
        case .missingToken: return 1003
        case .incorrectFormat: return 1004
        case .requiredField(_): return 1999
        case .custom(_, let code): return code
        }
    }
    
    static public var defaultCode : Int {
        return 400
    }
}
