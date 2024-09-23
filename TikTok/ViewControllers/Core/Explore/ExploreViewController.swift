//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import SnapKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    private var sections = [ExploreSection]()
    
    private lazy var searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView()
    
    //MARK: - Initializers
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ExploreManager.shared.delegate = self
        configureModels()
        
        setupViews()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    //MARK: - Setup Views Methods
    private func setUpSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        
        searchBar.delegate = self
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView = collectionView
    }
    
    private func configureModels() {
        // Banner
        sections.append(
            ExploreSection(
                type: .banners,
                cells: ExploreManager.shared.getExploreBanners().compactMap({
                    return ExploreCell.banner(viewModel: $0)
                })
            )
        )
        
        // Trending posts
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: ExploreManager.shared.getExploreTrendingPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        // Users
        sections.append(
            ExploreSection(
                type: .users,
                cells: ExploreManager.shared.getExploreCreators().compactMap({
                    return ExploreCell.user(viewModel: $0)
                })
            )
        )
        
        // Trending Hashtags
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: ExploreManager.shared.getExploreTrendingHashtags().compactMap({
                    return ExploreCell.hashtag(viewModel: $0)
                })
            )
        )
        
        // Recommended
        sections.append(
            ExploreSection(
                type: .recommended,
                cells: ExploreManager.shared.getExploreRecommendedPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        // Popular
        sections.append(
            ExploreSection(
                type: .popular,
                cells: ExploreManager.shared.getExplorePopularPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        // New/Recent
        sections.append(
            ExploreSection(
                type: .new,
                cells: ExploreManager.shared.getExploreRecentPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )
        
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        setUpSearchBar()
        setUpCollectionView()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
}

//MARK: - Extensions
//MARK: UICollectionViewDelegate
extension ExploreViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath) as? ExploreBannerCollectionViewCell else {
                fatalError("The CollectionView cold not dequeue a ExploreBannerCollectionViewCell in ExploreViewController")
            }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as? ExplorePostCollectionViewCell else {
                fatalError("The CollectionView cold not dequeue a ExplorePostCollectionViewCell in ExploreViewController")
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as? ExploreHashtagCollectionViewCell else {
                fatalError("The CollectionView cold not dequeue a ExploreHashtagCollectionViewCell in ExploreViewController")
            }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as? ExploreUserCollectionViewCell else {
                fatalError("The CollectionView cold not dequeue a ExploreUserCollectionViewCell in ExploreViewController")
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    
}

//MARK: UICollectionViewDelegate
extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            viewModel.handler()
        case .post(let viewModel):
            viewModel.handler()
        case .hashtag(let viewModel):
            viewModel.handler()
        case .user(let viewModel):
            viewModel.handler()
        }
    }
}

//MARK: UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Canсel", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc private func didTapCancel() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

//MARK: Sections Layout
extension ExploreViewController {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Groups
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case .trendingPosts, .recommended, .new:
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Groups
            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(300))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 2)
            
            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(300))
            let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .users:
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Groups
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case .trendingHashtags:
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Groups
            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
        case .popular:
            // Items
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Groups
            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(200))
            let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: horizontalGroupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}

//MARK: ExploreManagerDelegate
extension ExploreViewController: ExploreManagerDelegate {
    func pushViewController(_ vc: UIViewController) {
        HapticsManager.shared.vibrateForSelection()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapHashtag(_ hashtag: String) {
        HapticsManager.shared.vibrateForSelection()
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
}
