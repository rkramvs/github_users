//
//  UIColor+Extension.swift
//  Packages
//
//  Created by Ram Kumar on 01/10/24.
//
import UIKit

public extension UIColor {
    convenience init?(hex: String?) {
        guard let hex else { return nil }
        let _hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        guard Scanner(string: _hex).scanHexInt64(&int) else {
            return nil // Return nil if the hex string is invalid
        }
        
        let a, r, g, b: UInt64
        switch _hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil // Return nil if the hex code doesn't have 3, 6, or 8 digits
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}
