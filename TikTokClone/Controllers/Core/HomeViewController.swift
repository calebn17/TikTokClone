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
    
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        horizontalScrollView.delegate = self
        setUpFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
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
        vc.delegate = self
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
        vc.delegate = self
        forYouPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        //below line is needed to finish adding the child to the parent
        forYouPageViewController.didMove(toParent: self)
    }

    private func setUpHeaderButtons() {
       
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
    }

}

//MARK: - UIPage VC DataSource Methods
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
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {return nil}
        
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {return nil}
        
        guard index < (currentPosts.count - 1) else {return nil}
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    //computed var that gets the current collection
    var currentPosts: [PostModel] {
        
        if horizontalScrollView.contentOffset.x == 0 {
            //Following
            return followingPosts
        }
        
        //For You
        return forYouPosts
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2) {
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    
    func postViewController(_ vc: PostViewController, didTapcommentButtonFor post: PostModel) {
        //disables horizontal scrolling when comment tray is presented
        horizontalScrollView.isScrollEnabled = false
        //disables vertical scrolling when comment tray is presented
        if horizontalScrollView.contentOffset.x == 0 {
            //following feed
            //niling dataSource prevents scrolling because the vc doesn't have any data on the previous or next post
            followingPageViewController.dataSource = nil
        }
        else {
            //For You feed
            //niling dataSource prevents scrolling because the vc doesn't have any data on the previous or next post
            followingPageViewController.dataSource = nil
        }
        //present comment tray
        //using this implementation instead of a simple present in order to have that "tray" affect
        let vc = CommentViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
}

extension HomeViewController: CommentViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentViewController) {
        //close comments with animation
        let frame: CGRect = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: {[weak self] done in
            if done {
                DispatchQueue.main.async {
                    //remove Comment VC as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    //allow horizontal and vertical scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPageViewController.dataSource = self
                    self?.followingPageViewController.dataSource = self
                }
            }
        }
    }
}
