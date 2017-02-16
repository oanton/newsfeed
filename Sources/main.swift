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

import TurnstileCrypto

let connect = SQLiteConnect("./newsfeeddb")
createTablesIfNeed(connect: connect)

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
