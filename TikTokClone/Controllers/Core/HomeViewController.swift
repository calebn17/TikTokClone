//
//  ViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit

class HomeViewController: UIViewController {
    
//MARK: - Setup
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = .red
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    private let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
//MARK: - Configure Methods
    
    private func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpFollowingFeed() {
       
        guard let model = followingPosts.first else {return}
        
        let vc = PostViewController(model: model)
        followingPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setUpForYouFeed() {

        guard let model = forYouPosts.first else {return}
        
        let vc = PostViewController(model: model)
        forYouPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }


}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //making sure that the current vc can be cast as a PostVC, and then pull out it's model
        guard let fromPost = (viewController as? PostViewController)?.model else {return nil}
        //finding where the current vc's post is located in the referenced posts
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {return nil}
        //if it's the first vc then there's nothing before it
        if index == 0 {return nil}
        
        //getting the prior post and putting it in a PostViewController to return
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {return nil}
        
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {return nil}
        
        guard index < (currentPosts.count - 1) else {return nil}
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    var currentPosts: [PostModel] {
        
        if horizontalScrollView.contentOffset.x == 0 {
            //Following
            return followingPosts
        }
        
        //For You
        return forYouPosts
    }
    
    
}
