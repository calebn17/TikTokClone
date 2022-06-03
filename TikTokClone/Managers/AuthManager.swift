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
    
//MARK: - Public Methods
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
