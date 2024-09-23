//
//  RecordButton.swift
//  TikTok
//
//  Created by Влад Тимчук on 20.07.2024.
//

import UIKit

class RecordButton: UIButton {

    enum State {
        case recording
        case notRecording
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    
    //MARK: - Setup Methods
    private func setUpButtonView() {
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }
    
    public func toggle(for state: State) {
        switch state {
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = nil
        }
    }
}
