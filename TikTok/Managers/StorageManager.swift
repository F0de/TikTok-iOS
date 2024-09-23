//
//  StorageManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit
import FirebaseStorage

/// Manager object that deals with firebase storage
final class StorageManager {
    /// Shared singleton instance
    static let shared = StorageManager()
    /// Private constructor
    private init() {}
    
    /// Storage bucket reference
    private let storageBucket = Storage.storage().reference()
    
    //MARK: - Public
    /// Upload a new user video to firebase
    /// - Parameters:
    ///   - url: Local file url video
    ///   - fileName: Desired video file upload name
    ///   - completion: Async callback results closure
    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url) { _, error in
            completion(error == nil) // if error == nil return true else return false
        }
    }
    
    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: Async callback of result
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let path = "profile_pictures/\(username)/picture.png"
        storageBucket.child(path).putData(imageData) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
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
    }
    
    /// Generate a new file name
    /// - Returns: Returns a unique generated file name
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return "\(uuidString)_\(number)_\(unixTimestamp).mov"
    }
    
    /// Get download url of video post
    /// - Parameters:
    ///   - post: Post model to get url for
    ///   - completion: Async callback
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
    
}
