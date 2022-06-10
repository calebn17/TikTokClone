//
//  SignInViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit

class SignInViewController: UIViewController {
    
    //gets called in the TabBarVC when user successfully signs in
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
    }
    

   
}
