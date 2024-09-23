//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit

class NotificationsViewController: UIViewController {
    //MARK: - Properties
    private lazy var noNotificationsLabel = UILabel()
    private lazy var tableView = UITableView()
    private lazy var spinner = UIActivityIndicatorView(style: .large)
    
    var notifications = [Notification]()
    
    //MARK: - Initializers
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSubViews()
        
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    //MARK: - Setup Views Methods
    private func setupNoNotificationsLabel() {
        noNotificationsLabel.textColor = .secondaryLabel
        noNotificationsLabel.textAlignment = .center
        noNotificationsLabel.text = "No Notifications"
        noNotificationsLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.register(NotificationUserFollowTableViewCell.self, forCellReuseIdentifier: NotificationUserFollowTableViewCell.identifier)
        tableView.register(NotificationPostLikeTableViewCell.self, forCellReuseIdentifier: NotificationPostLikeTableViewCell.identifier)
        tableView.register(NotificationPostCommentTableViewCell.self, forCellReuseIdentifier: NotificationPostCommentTableViewCell.identifier)
        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    private func setupSpinner() {
        spinner.tintColor = .label
        spinner.startAnimating()
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Notifications"

        setupNoNotificationsLabel()
        setupTableView()
        setupSpinner()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(noNotificationsLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        noNotificationsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc private func didPullRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            guard let strongSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                strongSelf.notifications = notifications
                strongSelf.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - Extensions
extension NotificationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationPostLikeTableViewCell.identifier, for: indexPath) as? NotificationPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: postName, model: model)
            cell.delegate = self
            return cell
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationUserFollowTableViewCell.identifier, for: indexPath) as? NotificationUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: username, model: model)
            cell.delegate = self
            return cell
        case .postComment( let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationPostCommentTableViewCell.identifier, for: indexPath) as? NotificationPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: postName, model: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.id) { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if success {
                    strongSelf.notifications = strongSelf.notifications.filter { $0.isHidden == false }
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                }
            }
        }
    }
    
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
}

extension NotificationsViewController: NotificationUserFollowTableViewCellDelegate {
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.updateRelationship(for:
                                                    User(id: UUID().uuidString,
                                                         name: username,
                                                         profilePictureURL: nil),
                                                  follow: true)
        { success in
            if !success {
                // something went wront
            }
        }
    }
    
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapAvatarFor username: String) {
        HapticsManager.shared.vibrateForSelection()
        let profileVC = ProfileViewController(user: User(id: "123", name: username, profilePictureURL: nil))
        profileVC.title = username.uppercased()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension NotificationsViewController: NotificationPostLikeTableViewCellDelegate {
    func notificationPostLikeTableViewCell(_ cell: NotificationPostLikeTableViewCell, didTapPostWith id: String) {
        openPost(with: id)
    }
}

extension NotificationsViewController: NotificationPostCommentTableViewCellDelegate {
    func notificationPostCommentTableViewCell(_ cell: NotificationPostCommentTableViewCell, didTapPostWith id: String) {
        openPost(with: id)
    }
}

extension NotificationsViewController {
    // resolve the post model from database
    private func openPost(with id: String) {
        HapticsManager.shared.vibrateForSelection()
        let postVC = PostViewController(model: PostModel(id: id, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)))
        postVC.title = "Video"
        navigationController?.pushViewController(postVC, animated: true)
    }
}
