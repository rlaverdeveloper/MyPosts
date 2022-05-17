//
//  UserTests.swift
//  MyPostsTests
//
//  Created by Rubbermaid Laverde on 17/05/22.
//

import XCTest
@testable import MyPosts

class UserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserModel() throws {
        
        let resourceName = "user_response"
        let resourceExtension = "json"
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: resourceName, withExtension: resourceExtension) else {
            XCTFail("Unable to locate resource: \(resourceName).\(resourceExtension)")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Unable to get data from URL: \(url)")
            return
        }
        
        let posts = try? JSONDecoder().decode(User.self, from: data)
        XCTAssertNotNil(posts)
    }
}
