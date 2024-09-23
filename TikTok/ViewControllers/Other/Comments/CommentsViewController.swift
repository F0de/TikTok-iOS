//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 10.07.2024.
//

import UIKit
import SnapKit

protocol CommentViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
    //MARK: - Properties
    private let post: PostModel
    weak var delegate: CommentViewControllerDelegate?
    
    private lazy var closeButton = UIButton()
    private lazy var tableView = UITableView()
    
    private var comments = [PostCommentModel]()
    
    //MARK: - Initializers
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        fetchPostComments()
        
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    func fetchPostComments() {
        // DatabaseManager.shared.fetchComments
        self.comments = PostCommentModel.mockComments()
    }
    
    //MARK: - Setup Views Methods
    private func setupCloseButton() {
        closeButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(didtapClose), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setupCloseButton()
        setupTableView()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(closeButton)
        view.addSubview(tableView)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(15)
        }
    }
    
    //MARK: - Actions
    @objc private func didtapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
}

//MARK: - Extensions
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
