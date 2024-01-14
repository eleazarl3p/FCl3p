//
//  DummyData.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
struct DummyData {
    static let sampleFlight = Flight(name: "Test Flight",
                                     lastNose: "130",
                                     topCrotch: FlightCrotch(exist: true, distance: "50", hasPost: true),
                                     bottomCrotch: FlightCrotch(exist: true, distance: "40", hasPost: false),
                                     
                                     lfpPosts: [
                                        Post(name: "B1", distance: "15.0"),
                                        Post(name: "B2", distance: "15.0")],
                                     
                                     ufpPosts: [Post(name: "B1", distance: "15.0"),
                                                Post(name: "B2", distance: "15.0")],
                                     
                                     balusters: [
                                        Baluster(name: "A", distanceFirstNose: "14.11"),
                                        Baluster(name: "B", distanceFirstNose: "28.22"),
                                        Baluster(name: "C", distanceFirstNose: "42.33"),
                                        Baluster(name: "D", distanceFirstNose: "84.66"),
                                        Baluster(name: "E", distanceFirstNose: "105.0")],
                                     
                                     lfpEmbType: EmbeddedType.sleeve,
                                     ufpEmbType: EmbeddedType.sleeve,
                                     balusterEmbType : EmbeddedType.sleeve)
    
    static let sampleStair = Stair(name: "S001")
    static let sampleProject = Project(name: "P001", stairs: [sampleStair])
    static let projects = [sampleProject, sampleProject, sampleProject, sampleProject]
}
