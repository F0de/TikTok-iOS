//
//  PostViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    //MARK: - Properties
    var model: PostModel
    weak var delegate: PostViewControllerDelegate?
    
    private lazy var likeButton = UIButton()
    private lazy var likeImage = UIImageView()
    private lazy var commentButton = UIButton()
    private lazy var commentImage = UIImageView()
    private lazy var shareButton = UIButton()
    private lazy var shareImage = UIImageView()
    private lazy var captionLabel = UILabel()
    
    //MARK: - Initializers
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let colors: [UIColor] = [.red, .green, .black, .orange, .blue, .systemPink]
        view.backgroundColor = colors.randomElement()
        
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    //MARK: - Setup Views Methods
    private func setUpLikeButton() {
        if let image = UIImage(systemName: "heart.fill") {
            let resizedImage = resizeImage(image, scale: 2)
            likeImage.image = resizedImage.withTintColor(.white)
        }
        likeImage.isUserInteractionEnabled = false
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    private func setUpCommentButton() {
        if let image = UIImage(systemName: "text.bubble.fill") {
            let resizedImage = resizeImage(image, scale: 2)
            commentImage.image = resizedImage.withTintColor(.white)
        }
        commentImage.isUserInteractionEnabled = false
        
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
    }
    
    private func setUpShareButton() {
        if let image = UIImage(systemName: "square.and.arrow.up") {
            let resizedImage = resizeImage(image, scale: 2)
            shareImage.image = resizedImage.withTintColor(.white)
        }
        shareImage.isUserInteractionEnabled = false
        
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    private func resizeImage(_ image: UIImage, scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let render = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = render.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage
    }
    
    private func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func setUpCaption() {
        captionLabel.textAlignment = .left
        captionLabel.textColor = .white
        captionLabel.numberOfLines = 0
        captionLabel.text = "Check out this video! #fyp #foryou #foryoupage"
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setUpLikeButton()
        setUpCommentButton()
        setUpShareButton()
        setUpDoubleTapToLike()
        setUpCaption()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(likeButton)
        likeButton.addSubview(likeImage)
        view.addSubview(commentButton)
        commentButton.addSubview(commentImage)
        view.addSubview(shareButton)
        shareButton.addSubview(shareImage)
        view.addSubview(captionLabel)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            if let tabBarHeight = tabBarController?.tabBar.frame.height {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(tabBarHeight + 40)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            }
        }
        
        shareImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(shareButton.snp.top).offset(-10)
        }
        
        commentImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(commentButton.snp.top).offset(-10)
        }
        
        likeImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(60)
            if let tabBarHeight = tabBarController?.tabBar.frame.height {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(tabBarHeight + 20)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            }
        }
        
    }
    
    //MARK: - Actions
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        if model.isLikedByCurrentUser {
            if let image = UIImage(systemName: "heart.fill") {
                let resizedImage = resizeImage(image, scale: 2)
                likeImage.image = resizedImage.withTintColor(.systemRed)
            }
        } else if !model.isLikedByCurrentUser {
            if let image = UIImage(systemName: "heart.fill") {
                let resizedImage = resizeImage(image, scale: 2)
                likeImage.image = resizedImage.withTintColor(.white)
            }
        }
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
}
