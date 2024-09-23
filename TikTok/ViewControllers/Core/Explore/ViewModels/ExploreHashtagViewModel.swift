//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 14.07.2024.
//

import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int // number of posts associated with tag
    let handler: (() -> Void)
}
