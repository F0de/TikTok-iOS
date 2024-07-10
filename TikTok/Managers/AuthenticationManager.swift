//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
        
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //MARK: - Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
    
}
