//
//  ExplorePostCollectionViewCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/8/22.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {

    static let identifier = "ExplorePostCollectionViewCell"

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(captionLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let captionHeight: CGFloat = contentView.height/5
        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - captionHeight)
        captionLabel.frame = CGRect(x: 0, y: contentView.height - captionHeight, width: contentView.width, height: captionHeight)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
    }

    public func configure(with viewModel: ExplorePostViewModel) {
        captionLabel.text = viewModel.caption
        thumbnailImageView.image = viewModel.thumbnailImage
    }
}
