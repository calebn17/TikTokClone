//
//  NotifcationsUserFollowTableViewCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/16/22.
//

import UIKit

class NotifcationsUserFollowTableViewCell: UITableViewCell {

    static let identifier = "NotifcationsUserFollowTableViewCell"
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(x: 10, y: (contentView.height - iconSize)/2, width: iconSize, height: iconSize)
        
        followButton.sizeToFit()
        followButton.frame = CGRect(x: contentView.width - 110, y: (contentView.height - 40)/2, width: 100, height: 40)
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - 20 - followButton.width - iconSize, height: contentView.height - 40))
        label.frame = CGRect(x: avatarImageView.right, y: 0, width: labelSize.width, height: labelSize.height)
        dateLabel.frame = CGRect(x: avatarImageView.right, y: contentView.height - 40, width: contentView.width - avatarImageView.width - followButton.width, height: 40)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    public func configure(username: String, model: Notifications) {
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
}
