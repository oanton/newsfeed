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

extension Routes {
    static public func api(_ root: String = "/api", version: String = "1") -> Routes {
    var routes = Routes()
    let handler = Handler()
    let path = "\(root)/v\(version)"
        
    routes.add(method: .get, uri: "\(path)/services", handler: handler.handleGetServices)
    
    routes.add(method: .post, uri: "\(path)/registration", handler: handler.handlePostRegistration)
    routes.add(method: .get, uri: "\(path)/logout", handler: handler.handleGetLogout)
    routes.add(method: .get, uri: "\(path)/user/tags", handler: handler.handleGetUsersTags)
    routes.add(method: .post, uri: "\(path)/user/tags", handler: handler.handlePostUsersTags)
    routes.add(method: .delete, uri: "\(path)/user/tags", handler: handler.handleDeleteUsersTags)
    
    routes.add(method: .get, uri: "\(path)/articles", handler: handler.handleGetArticles)
    routes.add(method: .get, uri: "\(path)/articles/{article_id}/read", handler: handler.handleGetArticleMarkAsRead)
    routes.add(method: .get, uri: "\(path)/articles/{article_id}/unread", handler: handler.handleGetArticleMarkAsUnread)
    
    
    routes.add(method: .options, uri: "\(path)/*", handler: handler.handleOptions)
    return routes
}
    
}
