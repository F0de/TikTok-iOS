//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 09.08.2024.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
