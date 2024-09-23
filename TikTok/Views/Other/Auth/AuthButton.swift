//
//  AuthButton.swift
//  TikTok
//
//  Created by Влад Тимчук on 16.07.2024.
//

import UIKit

class AuthButton: UIButton {

    enum ButtonType {
        case signIn
        case signUp
        case plain
        
        var title: String {
            switch self {
            case .signIn:
                "Sign In"
            case .signUp:
                "Sign Up"
            case .plain:
                "-"
            }
        }
    }
    
    private let type: ButtonType
    
    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        setTitleColor(.white, for: .normal)
        
        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signUp: backgroundColor = .systemGreen
        case .plain:
            backgroundColor = .clear
            setTitleColor(.link, for: .normal)
        }
        
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
    }
}
