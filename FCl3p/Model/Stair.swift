//
//  Stair.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
import SwiftData

@Model
class Stair : Encodable {
   
    var name : String
    var flights : [Flight]
    var dateCreated : Date
    
    @Transient var toSend = false
    
    enum CodingKeys : String, CodingKey {
        case name, flighs
    }
    
    init( name: String, flights: [Flight] = [Flight](), dateCreated : Date = .now) {
      
        self.name = name
        self.flights = flights
        self.dateCreated = dateCreated
    }
    
    func copy() -> Stair {
        Stair(name: name, flights: flights.map({ flight in
            flight.copy()
        }))
    }
                                               
                                               
    
    func add(_ flight : Flight) {
        flights.insert(flight, at: 0)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(flights, forKey: .flighs)
    }
}

