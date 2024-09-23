//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok
//
//  Created by Влад Тимчук on 24.07.2024.
//

import UIKit
import SnapKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarWith viewModel: ProfileHeaderViewModel)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    var viewModel: ProfileHeaderViewModel?
    
    private lazy var avatarImageView = UIImageView()
    private lazy var primaryButton = UIButton()
    private lazy var buttonsStackView = UIStackView()
    private lazy var followersButton = UIButton()
    private lazy var followingButton = UIButton()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        
        setupViews()
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayout()
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        // Set Up Header
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL)
        } else {
            avatarImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        } else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
    //MARK: - Setup Views Methods
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .secondarySystemBackground
        avatarImageView.layer.cornerRadius = 65
        avatarImageView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
    }
    
    private func setupPrimaryButton() {
        primaryButton.layer.cornerRadius = 8
        primaryButton.layer.masksToBounds = true
        primaryButton.backgroundColor = .systemPink
        primaryButton.setTitle("Follow", for: .normal)
        primaryButton.setTitleColor(.label, for: .normal)
        primaryButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
    }
    
    private func setupFollowersButton() {
        followersButton.layer.cornerRadius = 8
        followersButton.layer.masksToBounds = true
        followersButton.setTitle("0\nFollowers", for: .normal)
        followersButton.setTitleColor(.label, for: .normal)
        followersButton.titleLabel?.textAlignment = .center
        followersButton.titleLabel?.numberOfLines = 2
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
    }
    
    private func setupFollowingButton() {
        followingButton.layer.cornerRadius = 8
        followingButton.layer.masksToBounds = true
        followingButton.setTitle("0\nFollowing", for: .normal)
        followingButton.setTitleColor(.label, for: .normal)
        followingButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.numberOfLines = 2
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = CGFloat(10)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupAvatarImageView()
        setupPrimaryButton()
        setupFollowersButton()
        setupFollowingButton()
        setupButtonsStackView()
    }
 
    //MARK: - Setting
    private func addSubViews() {
        addSubview(avatarImageView)
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(followersButton)
        buttonsStackView.addArrangedSubview(followingButton)
        addSubview(primaryButton)
    }

    //MARK: - Layout
    private func setUpLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(130)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        followersButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        followingButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        primaryButton.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(210)
            make.height.equalTo(44)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapPrimaryButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc private func didTapFollowersButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc private func didTapFollowingButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    @objc private func didTapAvatar() {
        guard let viewModel = self.viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapAvatarWith: viewModel)
    }
}
