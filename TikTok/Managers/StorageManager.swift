//
//  StorageManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let database = Storage.storage().reference()
    
    //MARK: - Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideo(from url: URL) {
        
    }
    
}
