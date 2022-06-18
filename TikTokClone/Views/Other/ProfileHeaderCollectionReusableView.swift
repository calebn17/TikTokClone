//
//  ProfileHeaderCollectionReusableView.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/17/22.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    private var viewModel: ProfileHeaderViewModel?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    //Follow or Edit Profile
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("0\nFollowers", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("0\nFollowing", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubViews()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(x: (width - avatarSize)/2, y: 5, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarSize/2
        
        followersButton.frame = CGRect(x: (width - 210)/2, y: avatarImageView.bottom + 10, width: 100, height: 60)
        followingButton.frame = CGRect(x: followersButton.right+10, y: avatarImageView.bottom + 10, width: 100, height: 60)
        
        primaryButton.frame = CGRect(x: (width - 220)/2, y: followingButton.bottom + 15, width: 220, height: 44)
    }
    
    private func addSubViews() {
        addSubview(avatarImageView)
        addSubview(primaryButton)
        addSubview(followingButton)
        addSubview(followersButton)
    }
    
    private func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        
        let tap = UIGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
        avatarImageView.isUserInteractionEnabled = true
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
        else {
            avatarImageView.image = UIImage(named: "test")
        }
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        }
        else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
    @objc private func didTapPrimaryButton() {
        guard let viewModel = viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc private func didTapFollowingButton() {
        guard let viewModel = viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    @objc private func didTapFollowersButton() {
        guard let viewModel = viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc private func didTapAvatar() {
        guard let viewModel = viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapAvatarFor: viewModel)
    }
}
