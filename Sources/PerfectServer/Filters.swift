//
//  Filters.swift
//  Newsfeed
//
//  Created by Raven on 30.03.17.
//
//

import Foundation
import PerfectHTTP
import PerfectLogger
import PerfectSession

public struct Driver {
    public var corsFilter: (HTTPRequestFilter, HTTPFilterPriority)
    public var notFoundFilter: (HTTPResponseFilter, HTTPFilterPriority)
    public var jsonFilter: (HTTPResponseFilter, HTTPFilterPriority)
    
    public init() {
        notFoundFilter = (Filter404(), HTTPFilterPriority.high)
        corsFilter = (CORS(), HTTPFilterPriority.high)
        jsonFilter = (JSON(), HTTPFilterPriority.high)
    }
}

struct CORS: HTTPRequestFilter {
    
    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        CORSheaders.make(request, response)
        callback(HTTPRequestFilterResult.continue(request, response))
    }
}

struct JSON: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        response.setHeader(.contentType, value: "application/json")
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        response.setHeader(.contentType, value: "application/json")
        callback(.continue)
    }
}



struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.prepareFail(messages: ["The file \(response.request.path) was not found."], code: response.status.code)
            callback(.done)
        } else {
            callback(.continue)
        }
    }
}

