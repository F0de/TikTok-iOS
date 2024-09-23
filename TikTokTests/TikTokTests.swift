//
//  TikTokTests.swift
//  TikTokTests
//
//  Created by Влад Тимчук on 19.09.2024.
//

import XCTest

@testable import TikTok

final class TikTokTests: XCTestCase {
    func testPostChildPath() {
        let id = UUID().uuidString
        let user = User(id: "123", name: "billgates", profilePictureURL: nil)
        var post = PostModel(id: id, user: user)
        XCTAssertTrue(post.caption.isEmpty)
        post.caption = "Hello, world!"
        XCTAssertFalse(post.caption.isEmpty)
        XCTAssertEqual(post.caption, "Hello, world!")
        XCTAssertEqual(post.videoChildPath, "videos/billgates/")
    }
}
