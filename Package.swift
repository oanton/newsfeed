//
//  Package.swift
//  Newsfeed
//
//  Created by Anton Nebylytsia on 15.02.17.
//
//

import PackageDescription

let package = Package(
    name: "Newsfeed",
    targets: [
        Target(name: "Newsfeed", dependencies: []),
        Target(name: "PerfectServer", dependencies: ["Newsfeed"])
    ],
    dependencies: [
        // Perfect
	    .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/dabfleming/Perfect-RequestLogger.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/oanton/Perfect-Session.git", majorVersion: 1),

        // misc
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)..<Version(3, .max, .max)),
        .Package(url: "https://github.com/oanton/SQLite-StORM.git", majorVersion: 1),
        .Package(url: "https://github.com/walkline/RSSProvider.git", majorVersion: 1),
    ]
)
