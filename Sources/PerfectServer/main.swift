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

// Array of acceptable hostnames for incoming requets
// To enable CORS on all, have a single entry, *
SessionConfig.CORS.acceptableHostnames = ["*"]

// However if you wish to enable specific domains:
//SessionConfig.CORS.acceptableHostnames.append("0.0.0.0")

// Wildcards can also be used at the start or end of hosts
//SessionConfig.CORS.acceptableHostnames.append("*.example.com")
//SessionConfig.CORS.acceptableHostnames.append("http://www.domain.*")

// Array of acceptable methods
public var methods: [HTTPMethod] = [.get, .post, .put]

// An array of custom headers allowed
public var customHeaders = [String]()

// Access-Control-Allow-Credentials true/false.
// Standard CORS requests do not send or set any cookies by default.
// In order to include cookies as part of the request enable the client to do so by setting to true
public var withCredentials = false

// Max Age (seconds) of request / OPTION caching.
// Set to 0 for no caching (default)
public var maxAge = 3600

let connect = SQLiteConnect("./newsfeeddb")
connect.createTablesIfNeeded()

/* 
 // Test code for create and fetch data via StORM
let user = UserModel(connect)
user.hash = URandom().secureToken
try user.save()

try user.findAll()
for obj in user.rows() {
    print("\(obj.id) - \(obj.hash)")
}
*/


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
