//
//  Routers.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 15.02.17.
//
//


import PerfectHTTP

// This function creates the routes
// Handlers are in Handlers.swift
public func makeJSONRoutes(_ root: String = "/api/v1") -> Routes {
    var routes = Routes()
    
    routes.add(method: .get, uri: "\(root)/ping", handler: pingHandler)
    routes.add(method: .get, uri: "\(root)/services", handler: User.registrationHandler)
    return routes
}
