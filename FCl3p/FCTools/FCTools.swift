//
//  FCTools.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation

struct Fraction {
    var numerator: Double
    var denominator: Double
    
    var doubleValue: Double {
        return numerator / denominator
    }
    
    init?(from string: String) {
        let components = string.components(separatedBy: "/")
        guard components.count == 2,
              let numerator = Double(components[0]),
              let denominator = Double(components[1]) else { return nil }
        self.numerator = numerator
        self.denominator = denominator
    }
}

func convertFeetToInches(_ feet: String) -> Double {
    let parts = feet.components(separatedBy: " ")
    var inches: Double = 0
    
    for part in parts {
        if part.contains("-") {
            let feetAndInches = part.components(separatedBy: "-")
            if let feetPart = Double(feetAndInches[0]) {
                inches += feetPart * 12
            }
            if let inchPart = Double(feetAndInches[1]) {
                inches += inchPart
            }
        } else if let fractionPart = Fraction(from: part) {
            inches += fractionPart.doubleValue
        } else if let inchPart = Double(part) {
            inches += inchPart
        }
    }
    
    return inches
}

func inchesToDouble(_ value: String) -> Double? {
    // Handle whole numbers and decimals
    if let doubleValue = Double(value) {
        return doubleValue
    }
    
    // Handle fractions
    let components = value.split(separator: " ")
    if components.count == 2, let wholeNumber = Double(components[0]) {
        let fractionComponents = components[1].split(separator: "/").map { Double($0) }
        if fractionComponents.count == 2, let numerator = fractionComponents[0], let denominator = fractionComponents[1] {
            return wholeNumber + (numerator / denominator)
        }
    }
    return nil
}

func matches(_ string: String, regex: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
        return !results.isEmpty
    } catch let error {
        print("Invalid regex: \(error.localizedDescription)")
        return false
    }
}

func isFeetValue(_ string: String) -> Bool {
    
    return  ["^\\d+-\\d+$", "^\\d+-\\d+\\s\\d+$", "^\\d+-\\d+\\s\\d+/\\d+$"].contains { regex in
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
            return !results.isEmpty
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}

