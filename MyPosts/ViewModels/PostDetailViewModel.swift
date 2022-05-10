//
//  PostDetailViewModel.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Combine
import UIKit

protocol PostDetailViewModelProtocol {
    
    var user: Box<User?> { get }
    var comments: Box<[PostComment]> { get }
    var favoriteButtonImage: Box<UIImage?> { get }
    var animation: Box<AnimationStyle?> { get }
    var dismissViewController: Box<Bool> { get }
    var post: Post { get }
    
    var numberOfSections: Int { get }
    var rowsPerSection: [Int] { get }
    
    func getUserInfo()
    func getPostComments()
    func viewModelForDetailCell() -> PostDetailCellViewModelProtocol
    func viewModelForCommentCell(at indexPath: IndexPath) -> PostCommentCellViewModelProtocol
    func addPostToFavorites()
    func removePost()
}

protocol EditPostDelegate: AnyObject {
    
    func didChangeFavorite(isFavorite: Bool , postId: Int)
    func didRemove(postId: Int)
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    
    // MARK: - Properties
    
    var user: Box<User?> = Box(nil)
    var comments: Box<[PostComment]> = Box([])
    var favoriteButtonImage: Box<UIImage?> = Box(nil)
    var animation: Box<AnimationStyle?> = Box(.loading)
    var dismissViewController: Box<Bool> = Box(false)
    
    weak var delegate: EditPostDelegate?
    var numberOfSections: Int = 2
    var rowsPerSection: [Int] {
        return [1, comments.value.count]
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let service: PostsService
    var post: Post
    
    
    // MARK: - Initializers
    
    init(post: Post, service: PostsService) {
        
        self.post = post
        self.service = service
        setupFavoriteButtonImage()
    }
    
    
    // MARK: - Helper Methods
    
    func getUserInfo() {
        
        animation.value = .loading

        service.getUserInfo(userId: post.userId)
            .mapError { [weak self] error -> Error in

                guard let strongSelf = self else {
                    return error
                }

                strongSelf.animation.value = .error
                
                return error
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.animation.value = nil
                strongSelf.user.value = response
            })
            .store(in: &cancellables)
    }
    
    func getPostComments() {
        
        animation.value = .loading

        service.getPostComments(postId: post.id)
            .mapError { [weak self] error -> Error in

                guard let strongSelf = self else {
                    return error
                }

                strongSelf.animation.value = .error
                
                return error
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.animation.value = nil
                strongSelf.comments.value = response
            })
            .store(in: &cancellables)
    }
    
    func viewModelForDetailCell() -> PostDetailCellViewModelProtocol {
        
        return PostDetailCellViewModel(post: post, user: user.value)
    }
    
    func viewModelForCommentCell(at indexPath: IndexPath) -> PostCommentCellViewModelProtocol {
        
        return PostCommentCellViewModel(comment: comments.value[indexPath.row])
    }
    
    func addPostToFavorites() {
        
        post.isFavorite.toggle()
        setupFavoriteButtonImage()
        delegate?.didChangeFavorite(isFavorite: post.isFavorite, postId: post.id)
    }
    
    func removePost() {
        
        delegate?.didRemove(postId: post.id)
        dismissViewController.value = true
    }
    
    private func setupFavoriteButtonImage() {
        
        favoriteButtonImage.value = UIImage(systemName: post.isFavorite ? "star.fill" : "star")
    }
}
