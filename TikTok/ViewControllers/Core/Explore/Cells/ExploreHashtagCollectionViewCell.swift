//
//  ExploreHashtagCollectionViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 15.07.2024.
//

import UIKit
import SnapKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    private lazy var iconImageView = UIImageView()
    private lazy var hashtagLabel = UILabel()
    
    var iconSize = CGFloat()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconSize = contentView.height / 3
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        hashtagLabel.text = nil
    }
    
    //MARK: - Setup methods
    public func configure(with viewModel: ExploreHashtagViewModel) {
        iconImageView.image = viewModel.icon
        hashtagLabel.text = viewModel.text
    }
    
    private func setupCellStyle() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray5
        
        hashtagLabel.numberOfLines = 1
        hashtagLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupCellStyle()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
    }

    //MARK: - Layout
    private func setupLayout() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
}
