//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 20.07.2024.
//

import UIKit
import SnapKit
import ProgressHUD

class CaptionViewController: UIViewController {
    //MARK: - Properties
    let videoURL: URL
    private lazy var captionTextView = UITextView()
    
    //MARK: - Initializers
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    //MARK: - Setup Views Methods
    private func setupCaptionTextView() {
        captionTextView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        captionTextView.backgroundColor = .secondarySystemBackground
        captionTextView.layer.cornerRadius = 8
        captionTextView.layer.masksToBounds = true
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        
        setupCaptionTextView()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(captionTextView)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        captionTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(150)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapPost() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // Generate a video name that unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.animate("Posting")
        
        // Upload video
        StorageManager.shared.uploadVideo(from: videoURL, fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Update database
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption) { databaseUpdated in
                        if databaseUpdated {
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            // Reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                            self?.present(alert, animated: true)
                        }
                    }
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
