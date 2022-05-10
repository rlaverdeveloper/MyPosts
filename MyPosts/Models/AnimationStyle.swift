//
//  AnimationStyle.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Foundation

enum AnimationStyle: String {
    
    case loading, error, empty
    
    var message: String? {
        
        switch self {
        case .error:
            return "Oops! something went wrong. Please try again."
        case .empty:
            return "There are no posts to display."
        default:
            return nil
        }
    }
}
