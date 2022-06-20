//
//  StorageManager.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/3/22.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    //private init forces you/people to use the shared instance of the app
    private init() {}
    
//MARK: - Public Methods
    
    public func uploadVideoURL(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        guard let imageData = image.pngData() else {return}
        
        let path = "profile_picture/\(username)/picture.png"
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            self.storageBucket.child(path).downloadURL { url, error in
                guard let url = url else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return "\(uuidString)_\(number)_\(unixTimestamp).mov"
    }
    
    public func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(url))
            }
        }
    }
}
