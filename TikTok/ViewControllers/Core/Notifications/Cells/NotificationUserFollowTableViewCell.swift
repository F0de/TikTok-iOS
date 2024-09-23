//
//  NotificationUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 22.07.2024.
//

import UIKit
import SnapKit

protocol NotificationUserFollowTableViewCellDelegate: AnyObject {
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapFollowFor username: String)
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapAvatarFor username: String)
}

class NotificationUserFollowTableViewCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "NotificationUserFollowTableViewCell"
    weak var delegate: NotificationUserFollowTableViewCellDelegate?
    var username: String?
    
    private lazy var avatarImageView = UIImageView()
    private lazy var label = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var stackLabelsView = UIStackView()
    private lazy var followButton = UIButton()
    
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
    }
    
    //MARK: - Setup Methods
    public func configure(with username: String, model: Notification) {
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        self.username = username
    }
    
    private func setupAvatarImageView() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    private func setupLabel() {
        label.numberOfLines = 1
        label.textColor = .label
        label.sizeToFit()
    }
    
    private func setupDateLabel() {
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .secondaryLabel
        dateLabel.sizeToFit()
    }
    
    private func setupStackLabelsView() {
        stackLabelsView.axis = .vertical
    }
    
    private func setupFollowButton() {
        followButton.backgroundColor = .systemBlue
        followButton.layer.cornerRadius = 6
        followButton.layer.masksToBounds = true
        followButton.sizeToFit()
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        selectionStyle = .none
        
        setupAvatarImageView()
        setupLabel()
        setupDateLabel()
        setupStackLabelsView()
        setupFollowButton()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(stackLabelsView)
        stackLabelsView.addArrangedSubview(label)
        stackLabelsView.addArrangedSubview(dateLabel)
        contentView.addSubview(followButton)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        stackLabelsView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalTo(followButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapFollow() {
        guard let username = username else { return }
        
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationUserFollowTableViewCell(self, didTapFollowFor: username)
    }
    
    @objc private func didTapAvatar() {
        guard let username = username else { return }
        delegate?.notificationUserFollowTableViewCell(self, didTapAvatarFor: username)
    }

}
