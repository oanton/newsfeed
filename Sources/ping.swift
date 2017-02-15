//
//  ping.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 15.02.17.
//
//

import PerfectHTTP
import SwiftyJSON

func pingHandler(request: HTTPRequest, _ response: HTTPResponse) {
    
    var resp = [String: String]()
    resp["path"] = "\(request.path)"
    do {
        try response.setBody(json: resp)
    } catch {
        print(error)
    }
    response.setHeader(.contentType, value: "application/json")
    response.completed()
}
