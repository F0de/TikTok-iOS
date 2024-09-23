//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 15.07.2024.
//

import UIKit
import SnapKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ExplorePostCollectionViewCell"
    
    private lazy var thumbnailImageView = UIImageView()
    private lazy var caption = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        thumbnailImageView.image = nil
        caption.text = nil
    }
    
    //MARK: - Setup methods
    public func configure(with viewModel: ExplorePostViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
        caption.text = viewModel.caption
    }
    
    private func setupCellStyle() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8

        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        
        caption.numberOfLines = 0
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupCellStyle()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(caption)
    }

    //MARK: - Layout
    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-contentView.height/5)
        }
        
        caption.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(thumbnailImageView.snp.bottom)
        }
    }
    
    //MARK: - Actions
    
}
