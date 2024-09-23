//
//  ExploreManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 14.07.2024.
//

import UIKit

/// Delegate interface to notify manager events
protocol ExploreManagerDelegate: AnyObject {
    /// Notify a view controller should be pushed
    /// - Parameter vc: The view controller to present
    func pushViewController(_ vc: UIViewController)
    /// Notify a hashtag element was tapped
    /// - Parameter hashtag: The hashtag that was tapped
    func didTapHashtag(_ hashtag: String)
}

/// Manager that handles explore view content
final class ExploreManager {
    /// Shared singlton instance
    static let shared = ExploreManager()
    
    /// Private constructor
    private init() {}
    
    /// Delegate to notify of events
    weak var delegate: ExploreManagerDelegate?
    
    /// Represents banner action type
    enum BannerAction: String {
        /// Post type
        case post
        /// Hashtag search type
        case hashtag
        /// Creator type
        case user
    }
    
    //MARK: - Public methods
    /// Get explore data for banner
    /// - Returns: Return collection of models
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.banners.compactMap({ model in
            ExploreBannerViewModel(image: UIImage(named: model.image), title: model.title) { [weak self] in
                guard let action = BannerAction(rawValue: model.action) else {
                    return
                }
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemBackground
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                switch action {
                case .user:
                    // profile
                    break
                case .post:
                    // post
                    break
                case .hashtag:
                    // search for hashtag
                    break
                }
            }
        })
    }
    
    /// Get explore data for trending posts
    /// - Returns: Return collection of models
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.trendingPosts.compactMap({ model in
            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(id: postID, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    /// Get explore data for popular creators
    /// - Returns: Return collection of models
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.creators.compactMap({ model in
            ExploreUserViewModel(profilePicture: UIImage(named: model.image), username: model.username, followerCount: model.followers_count) { [weak self] in
                let userID = model.id
                DispatchQueue.main.async {
                    // Fetch user object from firebase
                    let vc = ProfileViewController(user: User(id: userID, name: "joe", profilePictureURL: nil))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    /// Get explore data for popular hashtags
    /// - Returns: Return collection of models
    public func getExploreTrendingHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(text: "#" + model.tag, icon: UIImage(systemName: model.image), count: model.count) { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(model.tag)
                }
            }
        })
    }
    
    /// Get explore data for recommended posts
    /// - Returns: Return collection of models
    public func getExploreRecommendedPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.recommended.compactMap({ model in
            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(id: postID, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    /// Get explore data for popular posts
    /// - Returns: Return collection of models
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.popular.compactMap({ model in
            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(id: postID, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    /// Get explore data for recent posts
    /// - Returns: Return collection of models
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        return exploreData.recentPosts.compactMap({ model in
            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(id: postID, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    //MARK: - Private methods
    /// Parse explore JSON data
    /// - Returns: Returns a optional response model
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "Explore", ofType: "json") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            
            do {
                let decodedData = try JSONDecoder().decode(ExploreResponse.self, from: data)
                return decodedData
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                return nil
            }
        } catch {
            print("Error retrieving Data from URL: \(error.localizedDescription)")
            return nil
        }
    }
    
}
