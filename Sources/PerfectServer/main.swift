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

SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames = ["*"]
SessionConfig.CORS.methods = [.get, .post, .put, .options]
SessionConfig.CORS.customHeaders = ["Authorization", "X-WSSE", "content-type", "origin", "accept", "accept-language"]
SessionConfig.CORS.maxAge = 60

let connect = SQLiteConnect("./newsfeed.sqlite3")
connect.createTablesIfNeeded()

let server = HTTPServer()
server.addRoutes(Routes.api())
server.serverPort = 8079

let driver = Driver()
server.setRequestFilters([driver.corsFilter])
server.setResponseFilters([driver.notFoundFilter])
server.setResponseFilters([driver.jsonFilter])

let logger = RequestLogger()
server.setRequestFilters([(logger, .high)])
server.setResponseFilters([(logger, .low)])


do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
