//
//  HomeViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 30.06.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var horizontalScrollView = UIScrollView()
    private lazy var followingPagingController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
    private lazy var forYouPagingController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
    lazy var segmentedControl = UISegmentedControl(items: ["Following", "For You"])
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    //MARK: - Setup Views Methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let currentStyle = traitCollection.userInterfaceStyle
            switch currentStyle {
            case .unspecified:
                segmentedControl.selectedSegmentTintColor = .white
                segmentedControl.tintColor = .black
            case .light:
                segmentedControl.selectedSegmentTintColor = .white
                segmentedControl.tintColor = .black
            case .dark:
                segmentedControl.selectedSegmentTintColor = .black
                segmentedControl.tintColor = .white
            @unknown default:
                segmentedControl.selectedSegmentTintColor = .white
                segmentedControl.tintColor = .black
            }
        }
    }
    
    private func setUpScrollView() {
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        
        horizontalScrollView.delegate = self
    }
    
    private func setUpHeaderButtons() {
        segmentedControl.selectedSegmentIndex = 1
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            segmentedControl.selectedSegmentTintColor = .black
            segmentedControl.tintColor = .white
        } else {
            segmentedControl.selectedSegmentTintColor = .black
            segmentedControl.tintColor = .white
        }
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }
    
    private func setUpFeed() {
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpFollowingFeed() {
        guard let model = followingPosts.first else {
            return
        }
        
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        followingPagingController.setViewControllers([postVC], direction: .forward, animated: false)
        followingPagingController.dataSource = self
    }
    
    private func setUpForYouFeed() {
        guard let model = forYouPosts.first else {
            return
        }
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        forYouPagingController.setViewControllers([postVC], direction: .forward, animated: false)
        forYouPagingController.dataSource = self
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setUpScrollView()
        setUpFeed()
        setUpHeaderButtons()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        view.addSubview(horizontalScrollView)
        
        addChild(followingPagingController)
        horizontalScrollView.addSubview(followingPagingController.view)
        followingPagingController.didMove(toParent: self)
        
        addChild(forYouPagingController)
        horizontalScrollView.addSubview(forYouPagingController.view)
        forYouPagingController.didMove(toParent: self)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        horizontalScrollView.bounces = false
        horizontalScrollView.frame = view.bounds
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)

        followingPagingController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)

        forYouPagingController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
    }
    
    //MARK: - Actions
    @objc private func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
    }
}

//MARK: Extensions
extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.id == fromPost.id
        }) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.id == fromPost.id
        }) else {
            return nil
        }
        
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    var currentPosts: [PostModel] {
        horizontalScrollView.contentOffset.x == 0 ? followingPosts : forYouPosts
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2) {
            segmentedControl.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width/2) {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            followingPagingController.dataSource = nil // disable scrolling
        } else {
            forYouPagingController.dataSource = nil // disable scrolling
        }
        
        HapticsManager.shared.vibrateForSelection()
        
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }

    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let vc = ProfileViewController(user: post.user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: CommentViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        // close comments with animation
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    // remove comment vc as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    
                    // allow horizontal and vertical scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPagingController.dataSource = self
                    self?.followingPagingController.dataSource = self
                }
            }
        }
    }
}
