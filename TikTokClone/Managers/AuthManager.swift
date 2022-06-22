//
//  AuthManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import Foundation
import FirebaseAuth

/// Manager responsible for sign in, up, and out
final class AuthManager {
    
    /// Shared singleton instance
    static let shared = AuthManager()
    
    /// Private initializer
    private init() {}
    
    /// Represents methods to signing in
    enum SignInMethod {
        case email      ///email and password method
        case facebook   ///facebook method
        case google     ///google method
    }
    
    /// Represents authentication errors
    enum AuthError: Error {
        case signInFailed
    }
    
//MARK: - Public Methods
    
    /// Represents if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Attempt to sign up
    /// - Parameters:
    ///   - username: desired user name
    ///   - email: desired user email
    ///   - password: desired user password
    ///   - completion: Async callback
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
    
    /// Attempt to sign in
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    ///   - completion: Async callback
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
    
    /// Attempt to sign out
    /// - Parameter completion: Async callback
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
