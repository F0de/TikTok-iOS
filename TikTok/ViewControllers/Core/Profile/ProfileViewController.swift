//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit
import ProgressHUD

class ProfileViewController: UIViewController {
    //MARK: - Properties
    var user: User
    private var posts = [PostModel]()
    private var followers = [String]()
    private var following = [String]()
    private var isFollower = false
    
    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return user.name.lowercased() == username.lowercased()
        }
        return false
    }
    
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    private lazy var collectionView = UICollectionView()
    
    //MARK: - Initializers
    init(user: User) {
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
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Views Methods
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ProfileHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        title = user.name.uppercased()
        view.backgroundColor = .systemBackground
        let username = UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me"
        if title == username {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        }
        
        setupCollectionView()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(collectionView)
    }

    //MARK: - Layout
    private func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

//MARK: - Extensions
extension ProfileViewController: UICollectionViewDelegateFlowLayout { 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = ((view.width - 12) / 3)
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

//MARK: UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: postModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getRelationships(for: user, type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }
        DatabaseManager.shared.getRelationships(for: user, type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            self?.following = following
        }
        
        DatabaseManager.shared.isValidRelationship(for: user, type: .followers) { [weak self] isFollower in
            defer {
                group.leave()
            }
            self?.isFollower = isFollower
        }
        
        group.notify(queue: .main) {
            let viewModel = ProfileHeaderViewModel(
                avatarImageURL: self.user.profilePictureURL,
                followerCount: self.followers.count,
                followingCount: self.following.count,
                isFollowing: self.isCurrentUserProfile ? nil : self.isFollower
            )
            header.configure(with: viewModel)
        }
        
        return header
    }
    
}

//MARK: UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        // Open post
        let post = posts[indexPath.row]
        let postVC = PostViewController(model: post)
        postVC.delegate = self
        postVC.title = "Videos"
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

//MARK: ProfileHeaderCollectionReusableViewDelegate
extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        HapticsManager.shared.vibrateForSelection()

        if isCurrentUserProfile {
            // Edit Profile
            let editProfileVC = EditProfileViewController()
            let navVC = UINavigationController(rootViewController: editProfileVC)
            present(navVC, animated: true)
        } else {
            // Follow or unfollow users profile we are viewing
            if self.isFollower {
                // Unfollow
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }
                    } else {
                        
                    }
                }
            } else {
                // Follow
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        HapticsManager.shared.vibrateForSelection()
        
        let followersVC = UserListViewController(type: .followers, user: user)
        followersVC.users = followers
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        HapticsManager.shared.vibrateForSelection()
        
        let followingVC = UserListViewController(type: .following, user: user)
        followingVC.users = following
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarWith viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        HapticsManager.shared.vibrateForSelection()
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentProfilePicturePicker(type: .photoLibrary)
        }))
        present(actionSheet, animated: true)
    }
    
    private func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

//MARK: UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        ProgressHUD.animate("Uploading")
        // upload and update UI
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    
                    HapticsManager.shared.vibrate(for: .success)

                    strongSelf.user = User(id: strongSelf.user.name, name: strongSelf.user.name, profilePictureURL: downloadURL)
                    
                    ProgressHUD.success("Updated!")
                    strongSelf.collectionView.reloadData()
                case .failure:
                    HapticsManager.shared.vibrate(for: .error)
                    
                    ProgressHUD.error("Failed to upload profile picture.")
                }
            }
        }
    }
}

//MARK: UINavigationControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate {
    
}

//MARK: PostViewControllerDelegate
extension ProfileViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        //TODO: Present comments
        
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let profileVC = ProfileViewController(user: post.user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

//MARK: CommentViewControllerDelegate
extension ProfileViewController: CommentViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        
    }
}
