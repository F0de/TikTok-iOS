//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 29.07.2024.
//

import UIKit
import SnapKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "PostCollectionViewCell"
    
    private lazy var imageView = UIImageView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
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
        imageView.image = nil
    }
    
    //MARK: - Setup Methods
    func configure(with post: PostModel) {
        StorageManager.shared.getDownloadURL(for: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("Got url: \(url)")
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self.imageView.image = UIImage(cgImage: cgImage)
                    } catch {
                        
                    }
                case .failure(let error):
                    print("Failed to download url: \(error)")
                }
            }
        }
    }
    
    private func setupImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        setupImageView()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(imageView)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
}
