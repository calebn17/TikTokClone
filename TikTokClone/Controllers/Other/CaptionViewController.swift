//
//  CaptionViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/15/22.
//

import UIKit

class CaptionViewController: UIViewController {
    
    private let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapPost() {
        //Generate a video name that is unique that is based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        //Upload video
        StorageManager.shared.uploadVideoURL(from: videoURL, fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    //Update DB
                    DataBaseManager.shared.insertPost(fileName: newVideoName) { databaseUpdated in
                        if databaseUpdated {
                            //Reset the camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                        else {
                            let alert = UIAlertController(title: "Oops", message: "We were unable to upload your video. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
                else {
                    let alert = UIAlertController(title: "Oops", message: "We were unable to upload your video. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
