//
//  UserListViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit

//MARK: - Setup
class UserListViewController: UIViewController {

    enum ListType {
        case followers
        case following
    }
    
    let user: User
    let type: ListType
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
//MARK: - Init
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

//MARK: - UITableView Methods

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello"
        return cell
    }
}
