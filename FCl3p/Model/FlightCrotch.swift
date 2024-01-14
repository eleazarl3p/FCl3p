//
//  FlightCrotch.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
import SwiftData

@Model
class FlightCrotch : NSCopying , Encodable {

    
   
    var exist : Bool 
    var distance : String
    var hasPost: Bool
    
    @Transient var dDistance : Double {
        if isFeetValue(distance) {
            return convertFeetToInches(distance)
        }
        
        return inchesToDouble(distance) ?? 0.0
    }
    
    enum CodingKeys : String, CodingKey {
        case exist, distance, hasPost
    }
    
    init(exist: Bool = false, distance: String = "18.0", hasPost: Bool = false) {
       
        self.exist = exist
        self.distance = distance
        self.hasPost = hasPost
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        FlightCrotch(exist: exist, distance: distance, hasPost: hasPost)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exist, forKey: .exist)
        try container.encode(distance, forKey: .distance)
        try container.encode(hasPost, forKey: .hasPost)
    }
}
