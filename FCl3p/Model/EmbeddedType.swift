//
//  EmbeddedType.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
enum EmbeddedType: String, CaseIterable, Codable, Identifiable {
    case none = "None"
    case plate = "Plate"
    case sleeve = "Sleeve"
    var id: String { self.rawValue }
}
