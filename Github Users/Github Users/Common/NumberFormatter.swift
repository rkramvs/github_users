//
//  NumberFormatter.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation

struct NumberFormat {
    
    static var numberFormatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.usesSignificantDigits = true
        numFormatter.minimumSignificantDigits = 1
        numFormatter.maximumSignificantDigits = 3
        return numFormatter
    }()
    
    static func formatNumber(_ num: Double) -> String {
        switch abs(num) {
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            return "\(numberFormatter.string(for: formatted) ?? "")b"
        case 1_000_000...:
            let formatted = num / 1_000_000
            return "\(numberFormatter.string(for: formatted) ?? "")m"
        case 1_000...:
            let formatted = num / 1_000
            return "\(numberFormatter.string(for: formatted) ?? "")k"
        default:
            return numberFormatter.string(for: num) ?? "\(num)"
        }
    }
}
