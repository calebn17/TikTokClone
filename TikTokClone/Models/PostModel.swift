//
//  PostModel.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import Foundation

struct PostModel {
    let identifier: String
    
    let user = User(username: "kanyewest", profilePictureURL: nil, identifier: UUID().uuidString)
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
