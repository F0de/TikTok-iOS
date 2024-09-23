//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import Foundation
import FirebaseAuth

/// Manager responsible for signing in, up and out
final class AuthManager {
    /// Singleton instance of the manager
    static let shared = AuthManager()
    /// Private constructor
    private init() {}
    
    /// Represents method to sign in
    enum SignInMethod {
        /// Email and password method
        case email
        /// Facebook method
        case facebook
        /// Google method
        case google
    }
    
    /// Represents errors that can occur in auth flows
    enum AuthError: Error {
        case signInFailed
    }
    
    //MARK: - Public
    /// Represents if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Attempt to sign in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async results callback
    public func signIn(with email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            
            DatabaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.set(username, forKey: "username")
                    print("Got usernmae: \(username)")
                }
            }
            
            // Successful sign in
            completion(.success(email))
        }
    }
    
    /// Attempt to sig up
    /// - Parameters:
    ///   - username: Desired username
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signUp(with username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Make sure that entered username is available
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            
            DatabaseManager.shared.insertUser(with: email, username: username, completion: completion)
        }
    }
    
    /// Attempt to sign out
    /// - Parameter completion: Async callback of sign out result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
}
