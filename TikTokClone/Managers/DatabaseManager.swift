//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
    //private init forces you/people to use the shared instance of the app
    private init() {}
    
//MARK: - Public Methods
    
    public func insertUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        //get current users key
        //insert new entry
        //create root users
        database.child("users").observeSingleEvent(of: .value) {[weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                //create users root node
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]
                ) { error, _ in
                    completion(error == nil)
                }
                return
            }
            usersDictionary[username] = ["email": email]
            //save new users object
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            let newEntry = [
                "name": fileName,
                "caption": caption
                ]
            if var posts = value["posts"] as? [[String: Any]] {
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    public func getNotifications(completion: @escaping ([Notifications]) -> Void) {
        completion(Notifications.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func follow(username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        
        let path = "users/\(user.username.lowercased())/posts"
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            let models: [PostModel] = posts.compactMap({
                var model = PostModel(identifier: UUID().uuidString,
                                      user: user)
                model.fileName = $0["name"] ?? ""
                model.caption = $0["caption"] ?? ""
                return model
            })
            completion(models)
        }
    }
    
    public func getRelationships(for user: User, type: UserListViewController.ListType, completion: @escaping ([String]) -> Void) {
        
        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
        print("Fetching path: \(path)")
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion([])
                return
            }
            completion(usernameCollection)
        }
    }
    
    public func isValidRelationship(for user: User, type: UserListViewController.ListType, completion: @escaping (Bool) -> Void) {
        
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {return}
        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
        print("Fetching path: \(path)")
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }
            completion(usernameCollection.contains(currentUserUsername))
        }
    }
    
    public func updateRelationship(for user: User, follow: Bool, completion: @escaping (Bool) -> Void) {
        
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {return}
        
        if follow {
            //Follow
            
            let path = "users/\(currentUserUsername)/following"
            //Insert in current user's following object
            database.child(path).observeSingleEvent(of: .value) { snapshot in
                let usernameToInsert = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            //Insert in target users followers object
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { snapshot in
                let usernameToInsert = currentUserUsername
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                else {
                    self.database.child(path2).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
        else {
            //Unfollow
            
            let path = "users/\(currentUserUsername)/following"
            //Remove from current user's following object
            database.child(path).observeSingleEvent(of: .value) { snapshot in
                let usernameToRemove = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: {$0 == usernameToRemove})
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            //Remove from target users followers object
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { snapshot in
                let usernameToRemove = currentUserUsername
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: {$0 == usernameToRemove})
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
    }
}
