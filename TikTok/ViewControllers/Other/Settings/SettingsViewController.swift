//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit
import SafariServices
import StoreKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var footer = UIView()
    private lazy var signOutButton = UIButton()
    
    var sections = [SettingsSection]()
    
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
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        
        footer.frame = CGRect(x: 0, y: 0, width: tableView.width, height: 100)
        tableView.tableFooterView = footer

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.systemRed, for: .normal)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        sections = [
            SettingsSection(title: "Preferences", options: [
                SettingsOption(title: "Save Videos", handler: { })
            ]),
            SettingsSection(title: "Enjoy the app?", options: [
                SettingsOption(title: "Rate App", handler: {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }),
                SettingsOption(title: "Share App", handler: {
                    guard let url = URL(string: "https://www.facebook.com") else {
                        return
                    }
                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    self.present(activityViewController, animated: true)
                })
            ]),
            SettingsSection(title: "Information", options: [
                SettingsOption(title: "Terms Of Service", handler: { [weak self] in
                    DispatchQueue.main.async {
                        guard let termsOfServiceURL = URL(string: "https://www.tiktok.com/legal/terms-of-use") else {
                            return
                        }
                        let termsOfServiceVC = SFSafariViewController(url: termsOfServiceURL)
                        self?.present(termsOfServiceVC, animated: true)
                    }
                }),
                SettingsOption(title: "Privacy Policy", handler: { [weak self] in
                    DispatchQueue.main.async {
                        guard let termsOfServiceURL = URL(string: "https://www.tiktok.com/legal/privacy-policy") else {
                            return
                        }
                        let termsOfServiceVC = SFSafariViewController(url: termsOfServiceURL)
                        self?.present(termsOfServiceVC, animated: true)
                    }
                })
            ])
        ]
        
        setupTableView()
        setupSignOutButton()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(tableView)
        footer.addSubview(signOutButton)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Would you like to sign out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.setValue(nil, forKey: "username")
                        UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                        let signInVC = SignInViewController()
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    } else {
                        // failed
                        let alert = UIAlertController(title: "Woops", message: "Something went wrong when signing out. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
}

//MARK: - Extensions
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        
        if model.title == "Save Videos" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

extension SettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        HapticsManager.shared.vibrateForSelection()
        
        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }
    
    
}
