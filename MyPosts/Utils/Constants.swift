//
//  Constants.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Foundation

struct Constants {
    
    struct Api {

        static let host = "jsonplaceholder.typicode.com"
        static let scheme = "https"

        static func getBaseURLComponents() -> URLComponents {

            var components = URLComponents()
            components.scheme = Constants.Api.scheme
            components.host = Constants.Api.host

            return components
        }

        struct Paths {

            static let posts = "/posts"
            static let users = "/users"
            static let comments = "/comments"
        }
    }
}
