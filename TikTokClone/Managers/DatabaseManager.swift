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
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
