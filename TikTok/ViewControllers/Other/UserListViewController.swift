//
//  UserListViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit

class UserListViewController: UIViewController {
    enum ListType: String {
        case followers
        case following
    }
    
    //MARK: - Properties
    let user: User
    let type: ListType
    public var users = [String]()
    
    private lazy var tableView = UITableView()
    private lazy var noUsersLabel = UILabel()
    
    
    //MARK: - Initializers
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if users.isEmpty {
            noUsersLabel.isHidden = false
        } else {
            noUsersLabel.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private func setupNoUsersLabel() {
        noUsersLabel.textAlignment = .center
        noUsersLabel.textColor = .secondaryLabel
        noUsersLabel.text = "No Users"
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        
        setupTableView()
        setupNoUsersLabel()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(noUsersLabel)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noUsersLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
}

//MARK: - Extensions
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].lowercased()
        return cell
    }
    
}

extension UserListViewController: UITableViewDelegate {
    
}
