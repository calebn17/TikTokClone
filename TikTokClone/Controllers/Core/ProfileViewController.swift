//
//  ProfileViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //title = user.username.uppercased()
    }
}
