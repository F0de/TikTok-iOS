//
//  ExploreCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 14.07.2024.
//

import Foundation

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}
