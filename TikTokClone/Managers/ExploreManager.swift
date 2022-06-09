//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/8/22.
//

import Foundation
import UIKit

final class ExploreManager {
    
    static let shared = ExploreManager()
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {return []}
        
        return exploreData.banners.compactMap({
            ExploreBannerViewModel(image: UIImage(named: $0.image), title: $0.title) {
                //empty for now
            }
        })
    }
    
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
