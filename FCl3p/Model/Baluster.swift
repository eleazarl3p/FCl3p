//
//  Baluster.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
import SwiftData

@Model
class Baluster : NSCopying, Encodable {
    
    var name : String
    var distanceFirstNose : String
    
    @Transient var dDistanceFirstNose : Double {
        if isFeetValue(distanceFirstNose) {
            return convertFeetToInches(distanceFirstNose)
        }
        return inchesToDouble(distanceFirstNose) ?? 0.0
    }
    
    
    enum CodingKeys : String, CodingKey {
        case name, distanceFirstNose //, embeddedType
    }
    
    init(name: String, distanceFirstNose: String = "0.0") {
       
        self.name = name
        self.distanceFirstNose = distanceFirstNose
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        Baluster(name: name, distanceFirstNose: distanceFirstNose)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distanceFirstNose, forKey: .distanceFirstNose)
    }
}
