//
//  Request.swift
//  Newsfeed
//
//  Created by MiniOS on 30.03.17.
//
//

import Foundation
import PerfectHTTP

extension HTTPRequest {
    public var jsonBody: Any? {
        
        guard let body = self.postBodyString else {
            return nil
        }
        let json: Any?
        do {
            json = try body.jsonDecode()
        } catch  {
            json = nil
        }
        return json
    }
}
