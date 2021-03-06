//
//  NotificationViewController.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//
// MARK: - Setup

import UIKit

class NotificationViewController: UIViewController {

    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(NotificationsPostCommentTableViewCell.self, forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier)
        table.register(NotifcationsPostLikeTableViewCell.self, forCellReuseIdentifier: NotifcationsPostLikeTableViewCell.identifier)
        table.register(NotificationsUserFollowTableViewCell.self, forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier)
        return table
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()

    private var notifications = [Notifications]()

// MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noNotificationsLabel)
        view.addSubview(spinner)
        tableView.delegate = self
        tableView.dataSource = self

        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control

        fetchNotifications()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }

    private func fetchNotifications() {
        DataBaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }

// MARK: - Configure Methods

    private func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }

// MARK: - Action Methods

    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()

        DataBaseManager.shared.getNotifications(completion: { [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        })
    }
}

// MARK: - TableView Methods

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]

        switch model.type {

        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifcationsPostLikeTableViewCell.identifier, for: indexPath) as? NotifcationsPostLikeTableViewCell
            else {return UITableViewCell()}
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell

        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsUserFollowTableViewCell.identifier, for: indexPath) as? NotificationsUserFollowTableViewCell
            else {return UITableViewCell()}
            cell.delegate = self
            cell.configure(username: username, model: model)
            return cell

        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsPostCommentTableViewCell.identifier, for: indexPath) as? NotificationsPostCommentTableViewCell
            else {return UITableViewCell()}
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}

        let model = notifications[indexPath.row]
        model.isHidden = true

        DataBaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self]success in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({$0.isHidden == false}) ?? []

                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - NotificationsUserFollowTableViewCellDelegate

extension NotificationViewController: NotificationsUserFollowTableViewCellDelegate {
    func notificationUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DataBaseManager.shared.follow(username: username) { success in
            if !success {
                print("Something failed")
            }
        }
    }

    func notificationUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        HapticsManager.shared.vibrateForSelection()
        let vc = ProfileViewController(user: User(username: username, profilePictureURL: nil, identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationViewController: NotifcationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(_ cell: NotifcationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationViewController {
    func openPost(with identifier: String) {
        HapticsManager.shared.vibrateForSelection()
        // resolve the post model from the DB
        let vc = PostViewController(model:
                                        PostModel(
                                            identifier: identifier,
                                            user: User(
                                                username: "kanyewest",
                                                profilePictureURL: nil,
                                                identifier: UUID().uuidString
                                            )))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
