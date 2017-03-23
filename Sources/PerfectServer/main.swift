//
//  main.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 15.02.17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectRequestLogger
import SQLiteStORM
import PerfectSession
import Newsfeed

SessionConfig.name = "TestingMemoryDrivers"
SessionConfig.idle = 3600

// Enabled, true or false.
// Default is false.
SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames = ["*"]
SessionConfig.CORS.methods = [.get, .post, .put, .options]
SessionConfig.CORS.customHeaders = ["Authorization", "X-WSSE"]
SessionConfig.CORS.maxAge = 60

let connect = SQLiteConnect("./newsfeeddb")
connect.createTablesIfNeeded()

let server = HTTPServer()

let sessionDriver = SessionMemoryDriver()

server.setRequestFilters([sessionDriver.requestFilter])
server.setResponseFilters([sessionDriver.responseFilter])


let logger = RequestLogger()
server.setRequestFilters([(logger, .high)])
server.setResponseFilters([(logger, .low)])

let jsonRoutes = makeJSONRoutes("/api/v1")
server.addRoutes(jsonRoutes)

server.serverPort = 8079
server.setResponseFilters([(Filter404(), .high)])

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
