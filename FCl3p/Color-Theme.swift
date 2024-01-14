//
//  Color-Theme.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var colorCrotch : Color {
        Color(red: 0.4235, green: 0.2039, blue: 0.1568)
    }
    
    static var colorPlate : Color {
        Color(red: 0.3803, green: 0.4039, blue: 0.4784)
    }
    
    static var colorSleeve : Color {
        Color(red: 0.4235, green: 0.2039, blue: 0.1568)
    }
    
    static var colorStairBorder : Color {
        Color(red: 0.5058, green: 0.5058, blue: 0.5019) // 180, 180, 179
    }
    
    static var colorStair : Color {
        Color(red: 0.7411, green: 0.7411, blue: 0.7411)
    }
    
    static var colorStick : Color {
        Color.brown
    }
    
    static var lightBlue : Color {
        Color(0xDAF5FF)
    }
}


extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
