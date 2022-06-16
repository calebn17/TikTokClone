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

class Notifications {
    
    var identifier = UUID().uuidString
    let text: String
    let date: Date
    let type: NotificationType
    var isHidden = false
    
    init(text: String, date: Date, type: NotificationType) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notifications]{
        let first =  Array(0...5).compactMap({Notifications(
            text: "Something happened: \($0)",
            date: Date(),
            type: .postComment(postName: "This is a comment"))
        })
        
        let second =  Array(0...5).compactMap({Notifications(
            text: "Something happened: \($0)",
            date: Date(),
            type: .postLike(postName: "this is a Like!"))
        })
        
        let third =  Array(0...5).compactMap({Notifications(
            text: "Something happened: \($0)",
            date: Date(),
            type: .userFollow(username: "random user"))
        })
        
        
        return first + second + third
    }
}
