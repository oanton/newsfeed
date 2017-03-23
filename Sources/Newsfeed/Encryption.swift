//
//  Encryption.swift
//  Newsfeed
//
//  Created by MiniOS on 23.03.17.
//
//

import Foundation
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
    var hexString : String {
        let s = String(self, radix: 16)
        if s.characters.count == 1 {
            return "0" + s
        }
        return s
    }
}

public class Encryption {
    static public func sha1(_ body:String) -> String {
        let digest = body.utf8.sha1
        return digest.map { $0.hexString }.joined(separator: "")
    }
}
