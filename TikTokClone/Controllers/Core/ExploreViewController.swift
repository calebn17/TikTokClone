//
//  ExploreViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var collectionView: UICollectionView?
    
    private var sections = [ExploreSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchBar()
        setUpCollectionView()
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureModels() {
        var cells = [ExploreCell]()
        for _ in 0...1000 {
            let cell = ExploreCell.banner(viewModel: ExploreBannerViewModel(image: nil, title: "Foo", handler: {
                
            }))
            cells.append(cell)
        }
        //Banner
        sections.append(ExploreSection(type: .banners, cells: cells))
        
        //Trending posts
        sections.append(ExploreSection(type: .trendingPosts, cells: [
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            }))
        ]))
        
        //Users
        sections.append(ExploreSection(type: .users, cells: [
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
            
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                                                                 
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "", followerCount: 0, handler: {
                
            }))
        ]))
        
        //Trending Hashtags
        sections.append(ExploreSection(type: .trendingHashtags, cells: [
            .hashtag(viewModel: ExploreHashtagViewModel(text: "", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "", icon: nil, count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "", icon: nil, count: 0, handler: {
                
            }))
        ]))
        
        //Recommended
        sections.append(ExploreSection(type: .recommended, cells: [
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            }))
        ]))
        
        //Popular
        sections.append(ExploreSection(type: .popular, cells: [
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            }))
        ]))
        
        //New/Recent
        sections.append(ExploreSection(type: .new, cells: [
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
            
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            })),
            .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {
                
            }))
        ]))
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        case .banners:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .trendingPosts:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .users:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .trendingHashtags:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .recommended:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .popular:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        case .new:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            //Return
            return sectionLayout
        }
        
        
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}
