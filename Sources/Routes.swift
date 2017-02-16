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
    
    routes.add(method: .get, uri: "\(root)/services", handler: ServiceModel.servicesHandler)
    
    routes.add(method: .get, uri: "\(root)/user/registration", handler: UserModel.registrationHandler)
    routes.add(method: .get, uri: "\(root)/user/tags", handler: UserModel.tagsHandler)
    routes.add(method: .post, uri: "\(root)/user/tags", handler: UserModel.addTagHandler)
    routes.add(method: .delete, uri: "\(root)/user/tags", handler: UserModel.deleteTagHandler)
    
    routes.add(method: .get, uri: "\(root)/articles", handler: ArticleModel.articlesHandler)
    routes.add(method: .get, uri: "\(root)/articles/{article_id}/read", handler: ArticleModel.readArticleHandler)
    routes.add(method: .get, uri: "\(root)/articles/{article_id}/unread", handler: ArticleModel.unreadArticleHandler)
    
    return routes
}
