//
//  HTTPResponse+SimpleResponse.swift
//  Newsfeed
//
//  Created by Anton on 20.02.17.
//
//

import PerfectHTTP

extension HTTPResponse {
    func sendSuccessReponseWithCurrentPath(request: HTTPRequest) {
        var data = [String: String]()
        data["path"] = request.path
        do {
            try self.setBody(json: successResponse(data: data))
        } catch {
            print(error)
        }
        self.setHeader(.contentType, value: "application/json")
        self.completed()
    }
}
