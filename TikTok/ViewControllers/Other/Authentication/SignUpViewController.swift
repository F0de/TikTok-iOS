//
//  SignUpViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit
import SafariServices

class SignUpViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    private lazy var logoImageView = UIImageView()
    private lazy var usernameField = AuthField(type: .username)
    private lazy var emailField = AuthField(type: .email)
    private lazy var passwordField = AuthField(type: .password)
    private lazy var signUpButton = AuthButton(type: .signUp, title: nil)
    private lazy var termsButton = AuthButton(type: .plain, title: "Terms of Service")

    var completion: (() -> Void)?
    
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
    private func setupLogo() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 10
        logoImageView.layer.masksToBounds = true
        logoImageView.image = UIImage(named: "logo")
    }
    
    private func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    private func configureFields() {
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        usernameField.inputAccessoryView = toolBar
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Create Account"
        
        setupLogo()
        configureButtons()
        configureFields()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        termsButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapSignUp() {
        didTapKeyboardDone()
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !username.contains(" "),
              !username.contains(".") else {
            let alert = UIAlertController(title: "Woops", message: "Please make sure to enter a valid username, email and password. Your password must be at least 6 characters long.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        AuthManager.shared.signUp(with: username, email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    
                    self?.dismiss(animated: true)
                } else {
                    HapticsManager.shared.vibrate(for: .error)

                    let alert = UIAlertController(title: "Signed Up Failed", message: "Something went wrong when trying to register. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapTerms() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/legal/page/row/terms-of-service/en") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapKeyboardDone() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
