//
//  PostsViewModel.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Combine
import UIKit

protocol PostsViewModelProtocol {
    
    var filteredPosts: Box<[Post]> { get }
    var animation: Box<AnimationStyle?> { get }
    var postDetailViewController: Box<UIViewController?> { get }
    var numberOfRows: Int { get }
    
    func getPosts()
    func deleteAllPosts()
    func didSelectItem(at indexPath: IndexPath)
    func viewModelForCell(at indexPath: IndexPath) -> PostCellViewModelProtocol
    func filterPosts(by criteria: FilterCriteria?)
}

enum FilterCriteria: Int {
    case all, favorites
}

final class PostsViewModel: PostsViewModelProtocol {
    
    // MARK: - Properties
    
    var filteredPosts: Box<[Post]> = Box([])
    var animation: Box<AnimationStyle?> = Box(nil)
    var postDetailViewController: Box<UIViewController?> = Box(nil)
    
    var numberOfRows: Int {
        return filteredPosts.value.count
    }
    
    private var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    private let service: PostsService
    private var filterCriteria: FilterCriteria = .all
    
    
    // MARK: - Initializers
    
    init(service: PostsService) {
        self.service = service
    }
    
    
    // MARK: - Helper Methods
    
    func getPosts() {
        
        animation.value = .loading

        service.getPosts()
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
                
                strongSelf.animation.value = response.isEmpty ? .empty : nil
                strongSelf.posts = response
                strongSelf.filterPosts(by: strongSelf.filterCriteria)
            })
            .store(in: &cancellables)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        let post = filteredPosts.value[indexPath.row]
        let viewModel = PostDetailViewModel(post: post, service: PostsServiceClient())
        viewModel.delegate = self
        let viewController = PostDetailViewController(viewModel: viewModel)
        postDetailViewController.value = viewController
    }
    
    func deleteAllPosts() {
        
        animation.value = .empty
                
        switch filterCriteria {
        case .all:
            posts.removeAll()
        case .favorites:
            posts = Array(Set(posts).subtracting(filteredPosts.value)).sorted { $0.id < $1.id }
        }
        
        filteredPosts.value.removeAll()
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> PostCellViewModelProtocol {
        
        let post = filteredPosts.value[indexPath.row]
        return PostCellViewModel(post: post)
    }
    
    func filterPosts(by criteria: FilterCriteria?) {
        
        guard let criteria = criteria else {
            return
        }
 
        filterCriteria = criteria
        
        switch criteria {
        case .all:
            filteredPosts.value = posts
        case .favorites:
            filteredPosts.value = posts.filter { $0.isFavorite }
            // filteredPosts.value = posts.sorted { $0.isFavorite && !$1.isFavorite }
        }
        
        if filteredPosts.value.isEmpty {
            animation.value = .empty
        }
    }
}


// MARK: - EditPostDelegate

extension PostsViewModel: EditPostDelegate {
    
    func didChangeFavorite(isFavorite: Bool, postId: Int) {
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isFavorite = isFavorite
            filterPosts(by: filterCriteria)
        }
    }
    
    func didRemove(postId: Int) {
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts.remove(at: index)
            filterPosts(by: filterCriteria)
        }
    }
}
