//
//  HTTPServer+Helper.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 2/16/17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            let data = failResponse(messages: ["The file \(response.request.path) was not found."], code: 404)
            do {
                try response.setBody(json: data)
            } catch {
                print(error)
            }
            jsonResponse(response)
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        } else {
            callback(.continue)
        }
    }
}

func jsonResponse(_ response: HTTPResponse) {
    response.setHeader(.accessControlAllowOrigin, value: "*")
    response.setHeader(.contentType, value: "application/json")
}

func successResponse(data:Any) -> [String: Any] {
    var response = [String: Any]()
    response["status"] = "success"
    response["data"] = data
    return response
}

func failResponse(messages:[String], code:Int) -> [String: Any] {
    var response = [String: Any]()
    response["status"] = "error"
    response["code"] = "\(code)"
    response["messages"] = messages
    return response
    
}

