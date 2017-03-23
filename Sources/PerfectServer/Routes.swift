//
//  Routers.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 15.02.17.
//
//


import PerfectHTTP

let handler = Handler()

// This function creates the routes
// Handlers are in Handlers.swift
public func makeJSONRoutes(_ root: String = "/api/v1") -> Routes {
    var routes = Routes()
    
    routes.add(method: .get, uri: "\(root)/services", handler: handler.handleGetServices)
    
    routes.add(method: .get, uri: "\(root)/registration", handler: handler.handleGetRegistration)
    routes.add(method: .get, uri: "\(root)/logout", handler: handler.handleGetLogout)
    routes.add(method: .get, uri: "\(root)/user/tags", handler: handler.handleGetUsersTags)
    routes.add(method: .post, uri: "\(root)/user/tags", handler: handler.handlePostUsersTags)
    routes.add(method: .delete, uri: "\(root)/user/tags", handler: handler.handleDeleteUsersTags)
    
    routes.add(method: .get, uri: "\(root)/articles", handler: handler.handleGetArticles)
    routes.add(method: .get, uri: "\(root)/articles/{article_id}/read", handler: handler.handleGetArticleMarkAsRead)
    routes.add(method: .get, uri: "\(root)/articles/{article_id}/unread", handler: handler.handleGetArticleMarkAsUnread)
    
    
    routes.add(method: .options, uri: "\(root)/*", handler: handler.handleOptions)
    return routes
}
