//
//  MockPostsService.swift
//  MyPostsTests
//
//  Created by Rubbermaid Laverde on 17/05/22.
//

import Foundation
import Combine
@testable import MyPosts

class MockPostsService: PostsService {
    
    private var simulateErrors = false
    
    init(simulateErrors: Bool = false) {
        self.simulateErrors = simulateErrors
    }
    
    func getPosts() -> AnyPublisher<[Post], Error> {
        
        if simulateErrors {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
                        
        return response(forResource: "posts_response", withExtension: "json", responseType: [Post].self)
    }
    
    func getUserInfo(userId: Int) -> AnyPublisher<User, Error> {
        
        if simulateErrors {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
        
        return response(forResource: "user_response", withExtension: "json", responseType: User.self)
    }
    
    func getPostComments(postId: Int) -> AnyPublisher<[PostComment], Error> {
        
        if simulateErrors {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
        
        return response(forResource: "post_comments_response", withExtension: "json", responseType: [PostComment].self)
    }
}


// MARK: - Helper Methods

private extension MockPostsService {
    
    func response<T>(forResource name: String, withExtension ext: String, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
        
        guard let response = try? JSONDecoder().decode(responseType, from: data) else {
            return Fail(error: NetworkError.badContent).eraseToAnyPublisher()
        }
        
        return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
