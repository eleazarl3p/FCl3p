//
//  Flight.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import Foundation
import SwiftData

//@Model
//class FFlight2 : Encodable {
//    var id : UUID
//    var name: String
//    
//    var riser: String
//    var bevel: String
//    var lastNose: String
//    var noseToPost: String
//    
//    var topCrotch : FlightCrotch
//    var bottomCrotch : FlightCrotch
//    
//    var lfpPosts : [Post]
//    var ufpPosts : [Post]
//    var balusters : [Baluster]
//    
//    var lfpEmbType : EmbeddedType
//    var ufpEmbType : EmbeddedType
//    var balusterEmbType : EmbeddedType
//    
//    var dateCreated : Date
//    
//    @Transient var valid = true
//    
//    @Transient var dRiser : Double {
//        inchesToDouble(riser) ?? 6.75
//    }
//    
//    @Transient var dBevel: Double {
//        inchesToDouble(bevel) ?? 7.4375
//    }
//    
//    @Transient var dLastNose : Double {
//        if isFeetValue(lastNose) {
//            return convertFeetToInches(lastNose)
//        }
//        
//        return inchesToDouble(lastNose) ?? 0.0
//    }
//    
//    @Transient var dNoseToPost : Double {
//        if isFeetValue(noseToPost) {
//            return convertFeetToInches(noseToPost)
//        }
//        
//        return inchesToDouble(noseToPost) ?? 0.0
//    }
//    
//    @Transient var numberOfSteps : Int {
//        Int(round(dLastNose / sqrt(144 + (dBevel * dBevel)))) + 1
//    }
//    
//    @Transient var lFlat : Double {
//        let tot_lfp = lfpPosts.reduce(0) { $0 + $1.dDistance }
//        return max(20.0, tot_lfp, bottomCrotch.exist ? bottomCrotch.dDistance : 0.0) + 12.0
//    }
//    
//    @Transient var uFlat : Double {
//        let tot_ufp = ufpPosts.reduce(0) { $0 + $1.dDistance }
//        return max(20.0, tot_ufp, topCrotch.exist ? topCrotch.dDistance : 0.0) + 12.0
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case name, riser, bevel, lastNose, noseToPost, topCrotch, bottomCrotch, lfpPosts, ufpPosts, balusters, lfpEmbType, ufpEmbType, balusterEmbType // exclude 'id'
//    }
//    
//    init(name: String, riser: String = "6 3/4", bevel: String = "7 7/16", lastNose: String = "18-0",
//         noseToPost: String = "5 1/2",
//         topCrotch: FlightCrotch = FlightCrotch(),
//         bottomCrotch: FlightCrotch = FlightCrotch(),
//         lfpPosts: [Post] = [Post](),
//         ufpPosts: [Post] = [Post](),
//         balusters: [Baluster] = [Baluster](),
//         lfpEmbType: EmbeddedType = EmbeddedType.none,
//         ufpEmbType: EmbeddedType = EmbeddedType.none,
//         balusterEmbType: EmbeddedType = EmbeddedType.none,
//         dateCreated : Date = .now) {
//        self.id = UUID()
//        self.name = name
//        self.riser = riser
//        self.bevel = bevel
//        self.lastNose = lastNose
//        self.noseToPost = noseToPost
//        self.topCrotch = topCrotch
//        self.bottomCrotch = bottomCrotch
//        self.lfpPosts = lfpPosts
//        self.ufpPosts = ufpPosts
//        self.balusters = balusters
//        self.lfpEmbType = lfpEmbType
//        self.ufpEmbType = ufpEmbType
//        self.balusterEmbType = balusterEmbType
//        self.dateCreated = dateCreated
//    }
//    
//    func copy () -> Flight {
//        Flight(name: name, riser: riser, bevel: bevel, lastNose: lastNose, noseToPost: noseToPost,
//               topCrotch: topCrotch.copy() as! FlightCrotch, bottomCrotch: bottomCrotch.copy() as! FlightCrotch,
//               lfpPosts: lfpPosts.map({$0.copy() as! Post}), ufpPosts: ufpPosts.map({$0.copy() as! Post}), balusters: balusters.map({$0.copy() as! Baluster}), lfpEmbType: lfpEmbType,
//               ufpEmbType: ufpEmbType, balusterEmbType: balusterEmbType)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(riser, forKey: .riser)
//        try container.encode(bevel, forKey: .bevel)
//        try container.encode(lastNose, forKey: .lastNose)
//        try container.encode(noseToPost, forKey: .noseToPost)
//        try container.encode(topCrotch, forKey: .topCrotch)
//        try container.encode(bottomCrotch, forKey: .bottomCrotch)
//        try container.encode(lfpPosts, forKey: .lfpPosts)
//        try container.encode(ufpPosts, forKey: .ufpPosts)
//        try container.encode(balusters, forKey: .balusters)
//        try container.encode(lfpEmbType, forKey: .lfpEmbType)
//        try container.encode(ufpEmbType, forKey: .ufpEmbType)
//        try container.encode(balusterEmbType, forKey: .balusterEmbType)
//        
//    }
//}


@Model
final class Flight :  Encodable, Sendable {
   
    var name: String
    
    var riser: String
    var bevel: String
    var lastNose: String
    var noseToPost: String

    var topCrotch : FlightCrotch
    var bottomCrotch : FlightCrotch
    
    var lfpPosts : [Post]
    var ufpPosts : [Post]
    var balusters : [Baluster]
    
    var lfpEmbType : EmbeddedType
    var ufpEmbType : EmbeddedType
    var balusterEmbType : EmbeddedType
    
    var dateCreated : Date
    
    @Transient var valid = true
    
    @Transient var dRiser : Double {
        inchesToDouble(riser) ?? 6.75
    }
    
    @Transient var dBevel: Double {
        inchesToDouble(bevel) ?? 7.4375
    }
    
    @Transient var dLastNose : Double {
        if isFeetValue(lastNose) {
            return convertFeetToInches(lastNose)
        }
        
        return inchesToDouble(lastNose) ?? 0.0
    }
    
    @Transient var dNoseToPost : Double {
        if isFeetValue(noseToPost) {
            return convertFeetToInches(noseToPost)
        }
        
        return inchesToDouble(noseToPost) ?? 0.0
    }
    
    @Transient var numberOfSteps : Int {
        Int(round(dLastNose / sqrt(144 + (dBevel * dBevel)))) + 1
    }
    
    @Transient var lFlat : Double {
        let tot_lfp = lfpPosts.reduce(0) { $0 + $1.dDistance }
        return max(20.0, tot_lfp, bottomCrotch.exist ? bottomCrotch.dDistance : 0.0) + 12.0
    }
    
    @Transient var uFlat : Double {
        let tot_ufp = ufpPosts.reduce(0) { $0 + $1.dDistance }
        return max(20.0, tot_ufp, topCrotch.exist ? topCrotch.dDistance : 0.0) + 12.0
    }
    
    enum CodingKeys: String, CodingKey {
        case name, riser, bevel, lastNose, noseToPost, topCrotch, bottomCrotch, lfpPosts, ufpPosts, balusters, lfpEmbType, ufpEmbType, balusterEmbType // exclude 'id'
    }
    
    init(name: String, riser: String = "6 3/4", bevel: String = "7 7/16", lastNose: String = "18-0",
         noseToPost: String = "5 1/2",
         topCrotch: FlightCrotch = FlightCrotch(),
         bottomCrotch: FlightCrotch = FlightCrotch(),
         lfpPosts: [Post] = [Post](),
         ufpPosts: [Post] = [Post](), 
         balusters: [Baluster] = [Baluster](),
         lfpEmbType: EmbeddedType = EmbeddedType.none,
         ufpEmbType: EmbeddedType = EmbeddedType.none, 
         balusterEmbType: EmbeddedType = EmbeddedType.none,
         dateCreated : Date = .now) {
      
        self.name = name
        self.riser = riser
        self.bevel = bevel
        self.lastNose = lastNose
        self.noseToPost = noseToPost
        self.topCrotch = topCrotch
        self.bottomCrotch = bottomCrotch
        self.lfpPosts = lfpPosts
        self.ufpPosts = ufpPosts
        self.balusters = balusters
        self.lfpEmbType = lfpEmbType
        self.ufpEmbType = ufpEmbType
        self.balusterEmbType = balusterEmbType
        self.dateCreated = dateCreated
    }
    
    func copy () -> Flight {
        Flight(name: name, riser: riser, bevel: bevel, lastNose: lastNose, noseToPost: noseToPost,
               topCrotch: topCrotch.copy() as! FlightCrotch, bottomCrotch: bottomCrotch.copy() as! FlightCrotch,
               lfpPosts: lfpPosts.map({$0.copy() as! Post}), ufpPosts: ufpPosts.map({$0.copy() as! Post}), balusters: balusters.map({$0.copy() as! Baluster}), lfpEmbType: lfpEmbType,
               ufpEmbType: ufpEmbType, balusterEmbType: balusterEmbType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(riser, forKey: .riser)
        try container.encode(bevel, forKey: .bevel)
        try container.encode(lastNose, forKey: .lastNose)
        try container.encode(noseToPost, forKey: .noseToPost)
        try container.encode(topCrotch, forKey: .topCrotch)
        try container.encode(bottomCrotch, forKey: .bottomCrotch)
        try container.encode(lfpPosts, forKey: .lfpPosts)
        try container.encode(ufpPosts, forKey: .ufpPosts)
        try container.encode(balusters, forKey: .balusters)
        try container.encode(lfpEmbType, forKey: .lfpEmbType)
        try container.encode(ufpEmbType, forKey: .ufpEmbType)
        try container.encode(balusterEmbType, forKey: .balusterEmbType)

    }
}
