//
//  PostComment.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 10/05/22.
//

import Foundation

struct PostComment: Codable {
    
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
