//
//  AuthField.swift
//  TikTok
//
//  Created by Влад Тимчук on 16.07.2024.
//

import UIKit

class AuthField: UITextField {
    
    enum FieldType {
        case username
        case email
        case password
        
        var title: String {
            switch self {
            case .username: "Username"
            case .email: "Email"
            case .password: "Password"
            }
        }
    }
    
    private let type: FieldType
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        } else if type == .email {
            textContentType = .emailAddress
            keyboardType = .emailAddress
        }
    }
}
