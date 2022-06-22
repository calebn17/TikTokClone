//
//  PostCommentModel.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/7/22.
//

import Foundation

struct PostCommentModel {
    let text: String
    let user: User
    let date: Date

    static func mockComments() -> [PostCommentModel] {
        let user = User(username: "kanyewest", profilePictureURL: nil, identifier: UUID().uuidString)
        var comments = [PostCommentModel]()
        let text = [
            "This is cool",
            "This is rad",
            "I'm learning so much"
        ]

        for comment in text {
            comments.append(PostCommentModel(text: comment, user: user, date: Date()))
        }

        return comments
    }
}
