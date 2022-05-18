//
//  PostsViewModelTests.swift
//  MyPostsTests
//
//  Created by Rubbermaid Laverde on 17/05/22.
//

import XCTest
@testable import MyPosts

class PostsViewModelTests: XCTestCase {
    
    var sut: PostsViewModelProtocol!
    var sutWithErrors: PostsViewModelProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = PostsViewModel(service: MockPostsService())
        sutWithErrors = PostsViewModel(service: MockPostsService(simulateErrors: true))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadingAnimationIsDisplayed() throws {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to display the loading animation")
        
        sut.animation.bind { animation in
            
            if animation == .loading {
                expectation.fulfill()
            }
        }
        
        sut.getPosts()
        
        wait(for: [expectation], timeout: 2)
    }

    func testGetPosts() throws {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                expectation.fulfill()
            }
        }
        
        sut.getPosts()
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertNil(sut.animation.value)
        XCTAssertEqual(sut.filteredPosts.value.count, 100)
    }
    
    func testChangeFavorite() throws {
        
        let postIdToSetAsFavorite = 1
        
        let postListExpectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        let changeFavoriteExpectation = XCTestExpectation(description: "Wait for the ViewModel to set a post as favorite")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                
                postListExpectation.fulfill()
                
                if posts.first(where: { $0.id == postIdToSetAsFavorite })?.isFavorite == true {
                    changeFavoriteExpectation.fulfill()
                }
            }
        }
        
        sut.getPosts()
        sut.didChangeFavorite(isFavorite: true, postId: postIdToSetAsFavorite)
        
        wait(for: [postListExpectation, changeFavoriteExpectation], timeout: 2)
    }
    
    func testRemoveOnePost() throws {
        
        let postIdToRemove = 1
        
        let postListExpectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        let removeExpectation = XCTestExpectation(description: "Wait for the ViewModel to remove a post")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                
                postListExpectation.fulfill()
                
                if !posts.contains(where: { $0.id == postIdToRemove }) {
                    removeExpectation.fulfill()
                }
            }
        }
        
        sut.getPosts()
        wait(for: [postListExpectation], timeout: 2)
        
        XCTAssertNil(sut.animation.value)
        XCTAssertEqual(sut.filteredPosts.value.count, 100)
        
        sut.didRemove(postId: postIdToRemove)
        wait(for: [removeExpectation], timeout: 2)
                
        XCTAssertNil(sut.animation.value)
        XCTAssertEqual(sut.filteredPosts.value.count, 99)
    }
    
    func testRemoveAllPosts() throws {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                expectation.fulfill()
            }
        }
        
        sut.getPosts()
        wait(for: [expectation], timeout: 2)
        
        sut.removeAllPosts()
        XCTAssert(sut.animation.value == .empty)
        XCTAssert(sut.filteredPosts.value.isEmpty)
    }
    
    func testFilterPosts() throws {
        
        let postIdToSetAsFavorite = 1
        
        let postListExpectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        let changeFavoriteExpectation = XCTestExpectation(description: "Wait for the ViewModel to set a post as favorite")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                
                postListExpectation.fulfill()
                
                if posts.first(where: { $0.id == postIdToSetAsFavorite })?.isFavorite == true {
                    changeFavoriteExpectation.fulfill()
                }
            }
        }
        
        sut.getPosts()
        sut.didChangeFavorite(isFavorite: true, postId: postIdToSetAsFavorite)
        
        wait(for: [postListExpectation, changeFavoriteExpectation], timeout: 2)
        
        sut.filterPosts(by: .favorites)
        XCTAssertEqual(sut.filteredPosts.value.count, 1)
        
        sut.filterPosts(by: .all)
        XCTAssertEqual(sut.filteredPosts.value.count, 100)
    }
    
    func testGetPostDetailViewController() {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to get the post detail view controller")
        
        sut.postDetailViewController.bind { viewController in

            if viewController != nil {
                expectation.fulfill()
            }
        }

        sut.getPosts()
        sut.didSelectItem(at: IndexPath(row: 0, section: 0))

        wait(for: [expectation], timeout: 2)
        
        XCTAssert(sut.postDetailViewController.value is PostDetailViewController)
    }
    
    func testGetCellViewModel() {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to get the post list")
        
        sut.filteredPosts.bind { posts in
            
            if !posts.isEmpty {
                expectation.fulfill()
            }
        }

        sut.getPosts()
        wait(for: [expectation], timeout: 2)
        
        let cellIndex = 0
        let cellViewModel = sut.viewModelForCell(at: IndexPath(row: cellIndex, section: 0))
        XCTAssert(cellViewModel.title.value == sut.filteredPosts.value[cellIndex].title)
    }
    
    func testGetPostsReturnsError() {
        
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to display the loading animation")
        
        sutWithErrors.animation.bind { animation in
            
            if animation == .loading {
                expectation.fulfill()
            }
        }
        
        sutWithErrors.getPosts()
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssert(sutWithErrors.animation.value == .error)
        XCTAssertEqual(sutWithErrors.filteredPosts.value.count, 0)
    }
}
