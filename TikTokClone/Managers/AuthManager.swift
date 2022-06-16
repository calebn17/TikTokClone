//
//  AuthManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    //private init forces you/people to use the shared instance of the app
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    enum AuthError: Error {
        case signInFailed
    }
    
//MARK: - Public Methods
    
    //computed value determining if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func signUp(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        //Make sure entered username is available
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.set(username, forKey: "username")
            DataBaseManager.shared.insertUser(with: email, username: username, completion: completion)
        }
    }
    
    public func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            DataBaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.set(username, forKey: "username")
                }
            }
            
            completion(.success(email))
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
