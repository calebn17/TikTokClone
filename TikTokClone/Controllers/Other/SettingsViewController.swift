//
//  SettingsViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import UIKit
import SafariServices

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [SettingsSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            SettingsSection(title: "Information",
                            options:
                                [SettingsOption(
                                    title: "Terms of Service", handler: {[weak self] in
                                        DispatchQueue.main.async {
                                            guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else {return}
                                            let vc = SFSafariViewController(url: url)
                                            self?.present(vc, animated: true, completion: nil)
                                        }
                                    }),
                                 SettingsOption(
                                     title: "Privacy", handler: {[weak self] in
                                         DispatchQueue.main.async {
                                             guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else {return}
                                             let vc = SFSafariViewController(url: url)
                                             self?.present(vc, animated: true, completion: nil)
                                         }
                                     }),
                                ]
                           )
            
        ]
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        createFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width - 200)/2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Would you like to sign out", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {[weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.set(nil, forKey: "username")
                        UserDefaults.standard.set(nil, forKey: "profile_picture_url")
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                        self?.navigationController?.popToRootViewController(animated: false)
                        self?.tabBarController?.selectedIndex = 0
                    }
                    else {
                        //failed
                        let alert = UIAlertController(title: "Oops", message: "Something went wrong went signing out. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
