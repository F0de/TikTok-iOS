//
//  NotificationPostLikeTableViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 22.07.2024.
//

import UIKit
import SnapKit

protocol NotificationPostLikeTableViewCellDelegate: AnyObject {
    func notificationPostLikeTableViewCell(_ cell: NotificationPostLikeTableViewCell, didTapPostWith id: String)
}

class NotificationPostLikeTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "NotificationPostLikeTableViewCell"
    weak var delegate: NotificationPostLikeTableViewCellDelegate?
    var postID: String?
    
    private lazy var postThumbnailImageView = UIImageView()
    private lazy var label = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var stackLabelsView = UIStackView()

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
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    //MARK: - Setup Methods
    public func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        postID = postFileName
    }
    
    private func setupPostThumbnailImageView() {
        postThumbnailImageView.layer.masksToBounds = true
        postThumbnailImageView.contentMode = .scaleAspectFill
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
    }
    
    private func setupLabel() {
        label.numberOfLines = 1
        label.textColor = .label
    }
    
    private func setupDateLabel() {
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .secondaryLabel
    }
    
    private func setupStackLabelsView() {
        stackLabelsView.axis = .vertical
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        selectionStyle = .none

        setupPostThumbnailImageView()
        setupLabel()
        setupDateLabel()
        setupStackLabelsView()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(stackLabelsView)
        stackLabelsView.addArrangedSubview(label)
        stackLabelsView.addArrangedSubview(dateLabel)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        postThumbnailImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(contentView.height-6)
        }
        
        stackLabelsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(postThumbnailImageView.snp.leading).offset(-10)
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
    @objc private func didTapPost() {
        guard let id = postID else { return }
        delegate?.notificationPostLikeTableViewCell(self, didTapPostWith: id)
    }
    
}
