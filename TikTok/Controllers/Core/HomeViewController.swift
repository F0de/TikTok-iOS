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
    private func setUpScrollView() {
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.isPagingEnabled = true
        
        horizontalScrollView.delegate = self
    }
    
    private func setUpHeaderButtons() {
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.backgroundColor = nil
        segmentedControl.selectedSegmentTintColor = .white
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
        
        followingPagingController.setViewControllers([PostViewController(model: model)], direction: .forward, animated: false)
        followingPagingController.dataSource = self
    }
    
    private func setUpForYouFeed() {
        guard let model = forYouPosts.first else {
            return
        }
        
        forYouPagingController.setViewControllers([PostViewController(model: model)], direction: .forward, animated: false)
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
