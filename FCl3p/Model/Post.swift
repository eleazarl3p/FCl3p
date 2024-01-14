//
//  Post.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
import SwiftData

@Model
class Post : NSCopying, Encodable {
  
    var name : String
    var distance: String
    
    @Transient var dDistance : Double {
        if isFeetValue(distance) {
            return convertFeetToInches(distance)
        }
        
        return inchesToDouble(distance) ?? 0.0
    }
    
    enum CodingKeys : String, CodingKey {
        case name, distance
    }
    
    init(name: String = "", distance: String = "12.0") {
       
        self.name = name
        self.distance = distance
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        Post(name: name, distance: distance)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distance, forKey: .distance)
    }
}
