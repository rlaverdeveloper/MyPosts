//
//  PostsService.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import Foundation
import Combine

protocol PostsService {
    
    func getPosts() -> AnyPublisher<[Post], Error>
    func getUserInfo(userId: Int) -> AnyPublisher<User, Error>
    func getPostComments(postId: Int) -> AnyPublisher<[PostComment], Error>
}

final class PostsServiceClient: PostsService {
    
    // MARK: - Properties
    
    private let apiClient = APIClient()
    
    
    // MARK: - Methods
    
    func getPosts() -> AnyPublisher<[Post], Error> {

        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = Constants.Api.Paths.posts

        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getUserInfo(userId: Int) -> AnyPublisher<User, Error> {
        
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = Constants.Api.Paths.users + "/\(userId)"
        
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getPostComments(postId: Int) -> AnyPublisher<[PostComment], Error> {
        
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = Constants.Api.Paths.comments
        urlComponents.queryItems = [URLQueryItem(name: "postId", value: String(postId))]
        
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
