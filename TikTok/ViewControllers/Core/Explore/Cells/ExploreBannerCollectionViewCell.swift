//
//  ExploreCollectionViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 15.07.2024.
//

import UIKit
import SnapKit

class ExploreBannerCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ExploreBannerCollectionViewCell"
    
    private lazy var imageView = UIImageView()
    private lazy var title = UILabel()
    
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
        imageView.image = nil
        title.text = nil
    }
    
    //MARK: - Setup methods
    public func configure(with viewModel: ExploreBannerViewModel) {
        imageView.image = viewModel.image
        title.text = viewModel.title
    }
    
    private func setupCellStyle() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
                
        title.numberOfLines = 1
        title.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupCellStyle()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(title)
    }

    //MARK: - Layout
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    //MARK: - Actions
    
}
