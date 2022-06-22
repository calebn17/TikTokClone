//
//  CommentTableViewCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/7/22.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.tintColor = .label
        return imageView
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()

        let imageSize: CGFloat = 40
        let commentLabelHeight = min(contentView.height - dateLabel.top, commentLabel.height)
        avatarImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: commentLabel.bottom,
            width: dateLabel.width,
            height: dateLabel.height
        )
        commentLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 5,
            width: contentView.width - avatarImageView.right - 10,
            height: commentLabelHeight
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }

    public func configure(with model: PostCommentModel) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL {
           // avatarImageView.image = SD
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }

    }
}
