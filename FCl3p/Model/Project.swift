//
//  Project.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
import SwiftData

@Model
class Project {
    //var id  = UUID()
    var name : String
    var dateCreated : Date
    var stairs = [Stair]()
    
    init( name: String, dateCreated: Date = .now, stairs: [Stair] = [Stair]()) {
        //self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.stairs = stairs
    }
    
    
    func copy() -> Project {
        Project(name: name, stairs: stairs.map({$0.copy()}))
    }
    
    func add(_ stair: Stair) {
        stairs.insert(stair, at: 0)
    }
}
