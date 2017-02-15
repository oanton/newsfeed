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
    response.setHeader(.contentType, value: "application/json")
    try! response.setBody(json: ["path": "\(request.path)"])
    response.completed()
}
