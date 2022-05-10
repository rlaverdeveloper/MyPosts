//
//  PostCellViewModel.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 9/05/22.
//

import UIKit

protocol PostCellViewModelProtocol {
    
    var title: Box<String> { get }
    var accesoryImage: Box<UIImage?> { get }
}

struct PostCellViewModel: PostCellViewModelProtocol {
    
    // MARK: - Properties
    
    var title: Box<String> = Box("")
    var accesoryImage: Box<UIImage?> = Box(nil)
    
    let post: Post

    
    // MARK: - Initializers
    
    init(post: Post) {
        
        self.post = post
        title.value = post.title
        accesoryImage.value = post.isFavorite ? UIImage(systemName: "star.fill") : nil
    }
}
