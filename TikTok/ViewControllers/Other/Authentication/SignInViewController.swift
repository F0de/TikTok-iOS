//
//  SignInViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit
import SafariServices

class SignInViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    private lazy var logoImageView = UIImageView()
    private lazy var emailField = AuthField(type: .email)
    private lazy var passwordField = AuthField(type: .password)
    private lazy var signInButton = AuthButton(type: .signIn, title: nil)
    private lazy var forgotPasswordButton = AuthButton(type: .plain, title: "Forgot Password")
    private lazy var signUpButton = AuthButton(type: .plain, title: "New User? Create Account")
    
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
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    private func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Sign In"
        
        setupLogo()
        configureButtons()
        configureFields()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signUpButton)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
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
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 40)
            make.height.equalTo(55)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapSignIn() {
        didTapKeyboardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            let alert = UIAlertController(title: "Woops", message: "Please enter a valid email and password to sign in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // success
                    HapticsManager.shared.vibrate(for: .success)

                    self?.dismiss(animated: true)
                    break
                case .failure:
                    HapticsManager.shared.vibrate(for: .error)

                    let alert = UIAlertController(title: "Sign In Failed", message: "Please check your email and password to try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(alert, animated: true)
                    self?.passwordField.text = nil
                }
            }
        }
    }
    
    @objc private func didTapSignUp() {
        didTapKeyboardDone()
        let signUpVC = SignUpViewController()
        signUpVC.title = "Create Account"
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/login/email/forget-password") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
