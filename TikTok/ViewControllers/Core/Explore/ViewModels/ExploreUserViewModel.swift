//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 14.07.2024.
//

import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
