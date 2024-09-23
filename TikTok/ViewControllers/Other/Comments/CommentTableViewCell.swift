//
//  CommentTableViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 12.07.2024.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "CommentTableViewCell"
    
    private lazy var avatarImageView = UIImageView()
    private lazy var commentLabel = UILabel()
    private lazy var dateLabel = UILabel()
        
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }
    
    //MARK: - Setup Methods
    public func configure(with model: PostCommentModel) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL {
            print(url)
            
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }
    
    private func setUpAvatarImageView() {
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.masksToBounds = true
    }
    
    private func setUpCommentLabel() {
        commentLabel.numberOfLines = 3
        commentLabel.textColor = .label
    }
    
    private func setUpDateLabel() {
        dateLabel.textColor = .secondaryLabel
    }

    
    //MARK: - Setting Views
    private func setupViews() {
        setUpAvatarImageView()
        setUpCommentLabel()
        setUpDateLabel()
        
        addSubViews()
        setUpLayout()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        addSubview(avatarImageView)
        addSubview(commentLabel)
        addSubview(dateLabel)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(44)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
        }
    }
    
    //MARK: - Actions

    
}
