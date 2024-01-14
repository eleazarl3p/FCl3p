//
//  EmbeddedShape.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
import SwiftUI


struct Plate : Shape {
    
    let x : Double
    let y : Double
    let factor: Double
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: x , y: y + factor * 1.0))
        path.addLine(to: CGPoint(x: x + 3 * factor, y: y + factor * 1.0))
        path.addLine(to: CGPoint(x: x + 3 * factor, y: y + factor * 6))
        path.addLine(to: CGPoint(x: x - 3 * factor, y: y + factor * 6))
        path.addLine(to: CGPoint(x: x - 3 * factor, y: y + factor * 1.0))
        path.addLine(to: CGPoint(x: x, y: y + factor * 1.0))
        
        return path
    }
    
}

struct Sleeve : Shape {
    let x : Double
    let y: Double
    
    let factor: Double
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: x , y: y + factor * 0.0))
        path.addLine(to: CGPoint(x: x + factor * 1.5, y: y + factor * 0.0))
        path.addLine(to: CGPoint(x: x + factor * 1.5, y: y + factor * 6))
        path.addLine(to: CGPoint(x: x - factor * 1.5, y: y + factor * 6))
        path.addLine(to: CGPoint(x: x - factor * 1.5, y: y + factor * 0))
        path.addLine(to: CGPoint(x: x, y: y + factor * 0.0))
        
        return path
    }
}

struct BalusterEmbed: Shape {
    //let numberOfSteps = 5
    
    let width : Double
    let height : Double
    let flight : Flight
    let factor : Double
    
    // local
    let riser = 7.5
    func path (in rect: CGRect) -> Path{
        
        var path = Path()
        
        let stepHeight = riser * factor
        let stepWidth = 12.0 * factor
        
        var x = 0.0
        var y = 0.0
        
        let lFlat = flight.lFlat * factor
        
        for baluster in flight.balusters {
            let distance = baluster.dDistanceFirstNose
            let step = Int(round(distance / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1
            
            x = lFlat + stepWidth * CGFloat(step)
            y = height - stepHeight * CGFloat(step + 1)
            
            
            if flight.balusterEmbType == .plate {
                path.addPath(Plate(x: x - stepWidth / 2, y: y, factor: factor).path(in: rect))
            } else if flight.balusterEmbType == .sleeve {
                path.addPath(Sleeve(x: x - stepWidth / 2, y: y, factor: factor).path(in: rect))
            }
        }
        
        return path
    }
}

struct LowerFlatEmbed: Shape {
    
    let width : Double
    let height : Double
    let flight : Flight
    let factor : Double
    //let connected : Bool // if has baluster or upper post, extend toprail to first nose
    
    let riser = 7.5
    func path(in rect: CGRect) -> Path {
        
        let lFlat = flight.lFlat * factor - factor
        
        let stepHeight = riser * factor
        
        var path = Path()
        
        var x = 0.0
        let y = height - stepHeight //+ factor * 2
        
        for post in flight.lfpPosts {
            x += post.dDistance * factor
            
            if flight.lfpEmbType == .plate {
                path.addPath(Plate(x: lFlat - x, y: y, factor: factor).path(in: rect))
                
            } else if flight.lfpEmbType == .sleeve {
                path.addPath(Sleeve(x: lFlat - x, y: y, factor: factor).path(in: rect))
            }
        }
        
        
        return path
    }
}

struct UpperFlatEmbed: Shape {
    let width : Double
    let height : Double
    let flight : Flight
    let factor : Double
    //let connected : Bool // if has baluster or upper post, extend toprail to first nose
    
    let riser = 7.5
    func path(in rect: CGRect) -> Path {
        
        let stepHeight = riser * factor
        
        var path = Path()
        
        let dx = flight.lFlat * factor + (Double(flight.numberOfSteps-1) * 12.0 * factor) - factor
        var x = 0.0
        let y = height - stepHeight + (factor * 0.0) - Double(flight.numberOfSteps) * stepHeight
        for post in flight.ufpPosts {
            x += post.dDistance * factor
            
            if flight.ufpEmbType == .plate {
                path.addPath(Plate(x: dx + x, y: y, factor: factor).path(in: rect))
                
            } else if flight.ufpEmbType == .sleeve {
                path.addPath(Sleeve(x: dx + x, y: y, factor: factor).path(in: rect))
            }
        }
        
        return path
    }
}
