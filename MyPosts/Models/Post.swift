//
//  Post.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Foundation

struct Post: Codable, Hashable {
    
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}
