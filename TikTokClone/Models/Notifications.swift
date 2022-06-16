//
//  Notifications.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/16/22.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
        }
    }
}

struct Notifications {
    let text: String
    let date: Date
    let type: NotificationType
    
    static func mockData() -> [Notifications]{
        return Array(0...100).compactMap({Notifications(
            text: "Something happened: \($0)",
            date: Date(),
            type: .userFollow(username: "charliedamelio"))
        })
    }
}
