//
//  ExploreCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/7/22.
//

import Foundation
import UIKit

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int //number of posts associated with tag
    let handler: (() -> Void)
}
struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
