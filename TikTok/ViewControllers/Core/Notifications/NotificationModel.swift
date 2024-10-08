//
//  NotificationModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 22.07.2024.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike: "postLike"
        case .userFollow: "userFollow"
        case .postComment: "postComment"
        }
    }
}

class Notification {
    let id = UUID().uuidString
    var isHidden = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        let first = Array(0...5).compactMap {
            Notification(text: "Something happened: \($0)",
                         type: .postComment(postName: "vfcxvbbxv"),
                         date: Date())
        }
        let second = Array(0...5).compactMap {
            Notification(text: "Something happened: \($0)",
                         type: .userFollow(username: "vfcxvbbxv"),
                         date: Date())
        }
        let third = Array(0...5).compactMap {
            Notification(text: "Something happened: \($0)",
                         type: .postLike(postName: "vfcxvbbxv"),
                         date: Date())
        }
        return first + second + third
    }
}
