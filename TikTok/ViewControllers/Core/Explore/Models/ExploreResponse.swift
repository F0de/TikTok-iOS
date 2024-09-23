//
//  ExploreResponse.swift
//  TikTok
//
//  Created by Влад Тимчук on 18.09.2024.
//


struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
