//
//  EditProfileViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 04.08.2024.
//

import UIKit
import SnapKit

class EditProfileViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Initializers
    
    //MARK: - Lifecycle
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
    
    //MARK: - Setting Views
    private func setupViews() {
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    //MARK: - Setting
    private func addSubViews() {
        
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        
    }
    
    //MARK: - Actions
    @objc func didTapClose() {
        dismiss(animated: true)
    }
}
