//
//  PostCommentCellViewModel.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 10/05/22.
//

import Foundation

protocol PostCommentCellViewModelProtocol {
    
    var title: Box<String?> { get }
}

struct PostCommentCellViewModel: PostCommentCellViewModelProtocol {
        
    // MARK: - Properties
    
    var title: Box<String?> = Box(nil)
    
    let comment: PostComment?

    
    // MARK: - Initializer
    
    init(comment: PostComment?) {
        
        self.comment = comment
        title.value = comment?.body
    }
}
