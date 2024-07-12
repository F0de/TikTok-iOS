//
//  Extensions.swift
//  TikTok
//
//  Created by Влад Тимчук on 05.07.2024.
//

import UIKit

extension UIView {
    var width: CGFloat { frame.size.width }
    var height: CGFloat { frame.size.height }
    var left: CGFloat { frame.origin.x }
    var right: CGFloat { left + width }
    var top: CGFloat { frame.origin.y }
    var bottom: CGFloat { top + height }
}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}
