//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 14.07.2024.
//

import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
