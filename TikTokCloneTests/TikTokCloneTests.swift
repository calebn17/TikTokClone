//
//  TikTokCloneTests.swift
//  TikTokCloneTests
//
//  Created by Caleb Ngai on 6/3/22.
//

import XCTest
@testable import TikTokClone
import StoreKit

class TikTokCloneTests: XCTestCase {

    func testPostChildPath() {
        let id = UUID().uuidString
        let user = User(username: "billgates", profilePictureURL: nil, identifier: "123")
        var post = PostModel(identifier: id, user: user)
        XCTAssertTrue(post.caption.isEmpty)
        post.caption = "Hello!"
        XCTAssertFalse(post.caption.isEmpty)
        XCTAssertEqual(post.videoChildPath, "videos/billgates/")
    }
    
    

}



