//
//  ExploreHashtagCollectionViewCell.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/8/22.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height/5
        iconImageView.frame = CGRect(x: 10, y: (contentView.height - iconSize)/2, width: iconSize, height: iconSize).integral
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagLabel.text = nil
        iconImageView.image = nil
    }
    
    public func configure(with viewModel: ExploreHashtagViewModel) {
        hashtagLabel.text = viewModel.text
        iconImageView.image = viewModel.icon
    }
}
