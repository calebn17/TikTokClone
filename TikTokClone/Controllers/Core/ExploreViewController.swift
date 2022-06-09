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
        sections.append(ExploreSection(type: .banners, cells:
                                        ExploreManager.shared.getExploreBanners().compactMap(
                                            //the "return" keyword here is optional, but probably more readable if I include it
                                            {return ExploreCell.banner(viewModel: $0)}
                                        )
                                      )
        )
        
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
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou", icon: UIImage(systemName: "house"), count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#iphone12", icon: UIImage(systemName: "airplane"), count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#tiktokcourse", icon: UIImage(systemName: "camera"), count: 1, handler: {
                
            })),
            .hashtag(viewModel: ExploreHashtagViewModel(text: "#macbook", icon: UIImage(systemName: "bell"), count: 0, handler: {
                
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
        collectionView.backgroundColor = .systemBackground
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
           break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
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
