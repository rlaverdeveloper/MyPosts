//
//  PostDetailCellViewModel.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 10/05/22.
//

import Foundation

protocol PostDetailCellViewModelProtocol {
    
    var title: Box<String?> { get }
    var body: Box<String?> { get }
    var username: Box<String?> { get }
    var name: Box<String?> { get }
    var email: Box<String?> { get }
    var phone: Box<String?> { get }
    var website: Box<String?> { get }
}

struct PostDetailCellViewModel: PostDetailCellViewModelProtocol {
        
    // MARK: - Properties
    
    var title: Box<String?> = Box(nil)
    var body: Box<String?> = Box(nil)
    var username: Box<String?> = Box(nil)
    var name: Box<String?> = Box(nil)
    var email: Box<String?> = Box(nil)
    var phone: Box<String?> = Box(nil)
    var website: Box<String?> = Box(nil)
    
    let post: Post?
    let user: User?

    
    // MARK: - Initializer
    
    init(post: Post?, user: User?) {
        
        self.post = post
        self.user = user
        
        title.value = post?.title
        body.value = post?.body
        username.value = user?.username
        name.value = "Name: " + (user?.name ?? "")
        email.value = "Email: " + (user?.email ?? "")
        phone.value = "Phone: " + (user?.phone ?? "")
        website.value = "Website: " + (user?.website ?? "")
    }
}
