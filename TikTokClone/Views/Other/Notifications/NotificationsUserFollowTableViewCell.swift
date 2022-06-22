//
//  NotifcationsUserFollowTableViewCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/16/22.
//

import UIKit

protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    func notificationUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String)
    func notificationUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String)
}

class NotificationsUserFollowTableViewCell: UITableViewCell {

    static let identifier = "NotifcationsUserFollowTableViewCell"
    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    
    var username: String?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapFollow() {
        guard let username = username else {return}
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        delegate?.notificationUserFollowTableViewCell(self, didTapFollowFor: username)
    }
    
    @objc private func didTapAvatar() {
        guard let username = username else {return}
        delegate?.notificationUserFollowTableViewCell(self, didTapAvatarFor: username)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = 50
        
        avatarImageView.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize)
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
        followButton.sizeToFit()
        
        followButton.frame = CGRect(
            x: contentView.width - 110,
            y: 10,
            width: 100,
            height: 30)
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width - 30 - followButton.width - iconSize,
            height: contentView.height - 40))
        
        label.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height)
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: label.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
        
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderColor = nil
        followButton.layer.borderWidth = 0
        
    }
    
    public func configure(username: String, model: Notifications) {
        self.username = username
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
}
