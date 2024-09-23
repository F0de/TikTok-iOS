//
//  ExploreUserCollectionViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 15.07.2024.
//

import UIKit
import SnapKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ExploreUserCollectionViewCell"
    
    private lazy var profilePictureImageView = UIImageView()
    private lazy var username = UILabel()
    
    var imageSize = CGFloat()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageSize = contentView.height - 55

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
        profilePictureImageView.image = nil
        username.text = nil
    }
    
    //MARK: - Setup methods
    public func configure(with viewModel: ExploreUserViewModel) {
        profilePictureImageView.image = viewModel.profilePicture
        username.text = viewModel.username
    }
    
    private func setupCellStyle() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        contentView.clipsToBounds = true
        
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        profilePictureImageView.layer.cornerRadius = imageSize/2
        profilePictureImageView.backgroundColor = .secondarySystemBackground
        
        username.numberOfLines = 1
        username.font = .systemFont(ofSize: 18, weight: .light)
        username.textAlignment = .center
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupCellStyle()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(username)
    }

    //MARK: - Layout
    private func setupLayout() {
        profilePictureImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }
        
        username.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(profilePictureImageView.snp.bottom)
        }
    }
    
    //MARK: - Actions
    
}
