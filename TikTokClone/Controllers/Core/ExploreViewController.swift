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
        
        //Banner
        var cells = [ExploreCell]()
        for _ in 0...1000 {
            let cell = ExploreCell.banner(viewModel: ExploreBannerViewModel(image: UIImage(named: "test"), title: "Foo", handler: {
                
            }))
            cells.append(cell)
        }
        sections.append(ExploreSection(type: .banners, cells: cells))
        
        //Trending posts
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(ExploreCell.post(viewModel: ExplorePostViewModel(thumbnailImage: UIImage(named: "test"), caption: "This was a really cool post and a long caption", handler: {
                
            })))
        }
        sections.append(ExploreSection(type: .trendingPosts, cells: posts))
        
        //Users
        sections.append(ExploreSection(type: .users, cells: [
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "charlie", followerCount: 0, handler: {
            
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "jason", followerCount: 0, handler: {
                                                                 
            })),
            .user(viewModel: ExploreUserViewModel(profilePicture: nil, username: "spiderman", followerCount: 0, handler: {
                
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
        sections.append(ExploreSection(type: .recommended, cells: posts))
        
        //Popular
        sections.append(ExploreSection(type: .popular, cells: posts))
        
        // New/Recent
        sections.append(ExploreSection(type: .new, cells: posts))
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
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
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath)
                    as? ExploreBannerCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath)
                    as? ExplorePostCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath)
                    as? ExploreHashtagCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath)
                    as? ExploreUserCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(with: viewModel)
            return cell
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}

//MARK: - Section Layouts
extension ExploreViewController {
    
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
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
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
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            //Return
            return sectionLayout
            
        case .trendingPosts, .recommended, .new:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item, count: 2
            )
            //putting the above vertical group into this horizontal group. one horizontal group with 2 rows essentially
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)),
                subitems: [verticalGroup]
            )
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
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
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)),
                subitems: [item]
            )
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            //Return
            return sectionLayout
        }
    }
}
