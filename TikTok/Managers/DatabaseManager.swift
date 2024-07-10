//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
