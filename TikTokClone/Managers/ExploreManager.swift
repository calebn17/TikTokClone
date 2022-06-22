//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/8/22.
//

import Foundation
import UIKit

/// Delegate interface to notify manager events
protocol ExploreManagerDelegate: AnyObject {
    
    /// Notify a view controller should be pushed
    ///  - Parameter vc: The view controller to present
    func pushViewController(_ vc: UIViewController)
    
    /// Notify a hashtag element was tapped
    ///  - Parameter hashtag: the tapped hashtag
    func didTapHashTag(_ hashtag: String)
}

/// Manager that handles explore view content
final class ExploreManager {
    
    /// Shared singleton instance
    static let shared = ExploreManager()
    
    /// Delegate to notify events
    weak var delegate: ExploreManagerDelegate?
    
    /// Represents banner action types
    enum BannerAction: String {
        case post       /// Post type
        case hashtag    /// Hashtag type
        case user       ///User Type
    }
    
    /// Gets explore data for banners
    /// - Returns: Returns collection of models
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.banners.compactMap({ model in
            ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title) {[weak self] in
                    guard let action = BannerAction(rawValue: model.action) else {return}
                    
                    DispatchQueue.main.async {
                        let vc = UIViewController()
                        vc.view.backgroundColor = .systemBackground
                        vc.title = action.rawValue.uppercased()
                        self?.delegate?.pushViewController(vc)
                        switch action {
                        case .user:
                            //profile
                            break
                        case .post:
                            //post
                            break
                        case .hashtag:
                            //search for hashtag
                            break
                        }
                    }
            }
        })
    }
    
    /// Gets explore data for popular creators
    /// - Returns: Returns collection of models
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.creators.compactMap({ model in
            ExploreUserViewModel(
                profilePicture: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count) {[weak self] in
                    
                    DispatchQueue.main.async {
                        let userId = model.id
                        //Fetch user object from firebase
                        let vc = ProfileViewController(user: User(username: "Joe", profilePictureURL: nil, identifier: userId))
                        
                        self?.delegate?.pushViewController(vc)
                    }
                }})
    }
    
    /// Gets explore data for hastags
    /// - Returns: Returns collection of models
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(
                text: "#" + model.tag,
                icon: UIImage(named: model.image),
                count: model.count) {[weak self] in
                    DispatchQueue.main.async {
                        self?.delegate?.didTapHashTag(model.tag)
                    }
                }})
    }
    
    /// Gets explore data for trending posts
    /// - Returns: Returns collection of models
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.trendingPosts.compactMap({model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {[weak self] in
                    DispatchQueue.main.async {
                        let postID = model.id
                        let vc = PostViewController(model: PostModel(identifier: postID,
                                                                     user: User(username: "kanyewest",
                                                                                profilePictureURL: nil,
                                                                                identifier: UUID().uuidString)))
                        self?.delegate?.pushViewController(vc)
                    }
                }})
    }
    
    /// Gets explore data for recent posts
    /// - Returns: Returns collection of models
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.recentPosts.compactMap({model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {[weak self] in
                    DispatchQueue.main.async {
                        let postID = model.id
                        let vc = PostViewController(model: PostModel(identifier: postID,
                                                                     user: User(username: "kanyewest",
                                                                                profilePictureURL: nil,
                                                                                identifier: UUID().uuidString)))
                        self?.delegate?.pushViewController(vc)
                    }
                }})
    }
    
    /// Gets explore data for popular posts
    /// - Returns: Returns collection of models
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.popular.compactMap({model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {[weak self] in
                    DispatchQueue.main.async {
                        let postID = model.id
                        let vc = PostViewController(model: PostModel(identifier: postID,
                                                                     user: User(username: "kanyewest",
                                                                                profilePictureURL: nil,
                                                                                identifier: UUID().uuidString)))
                        self?.delegate?.pushViewController(vc)
                    }
                }})
    }
    
    public func getExploreRecommendedPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.recommended.compactMap({model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {[weak self] in
                    DispatchQueue.main.async {
                        let postID = model.id
                        let vc = PostViewController(model: PostModel(identifier: postID,
                                                                     user: User(username: "kanyewest",
                                                                                profilePictureURL: nil,
                                                                                identifier: UUID().uuidString)))
                        self?.delegate?.pushViewController(vc)
                    }
                }})
    }
    
    /// Parse explore JSON data
    /// - Returns: Returns an optional response model
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {return nil}
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let results = try JSONDecoder().decode(ExploreResponse.self, from: data)
            return results
        }
        catch {
            print(error)
            return nil
        }
    }
}

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Posts]
    let creators: [Creator]
    let recentPosts: [Posts]
    let hashtags: [Hashtag]
    let popular: [Posts]
    let recommended: [Posts]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Posts: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag: Codable {
    let tag: String
    let image: String
    let count: Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
