//
//  ProfileHeaderCollectionReusableView.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/17/22.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: String)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: String)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: String)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
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
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
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
    }
    
    @objc private func didTapPrimaryButton() {
        
    }
    
    @objc private func didTapFollowingButton() {
        
    }
    
    @objc private func didTapFollowersButton() {
        
    }
}
