//
//  StickShape.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
import SwiftUI

struct UpperFlatStick: Shape {
    
    let width : Double
    let height : Double
    let flight : Flight
    
    let factor : Double
    let postHeight : Double
    
    
    let riser = 7.5
    func path(in rect: CGRect) -> Path {
        
        let lFlat = flight.lFlat * factor
        
        let stepHeight = riser * factor
        
        var path = Path()
        
        let dx = lFlat + (Double(flight.numberOfSteps-1) * 12.0 * factor) - factor
        var x = 0.0
        let y = height - stepHeight + (factor * 2.0) - Double(flight.numberOfSteps) * stepHeight
        
        for post in flight.ufpPosts {
            x += post.dDistance
            path.move(to: CGPoint(x: dx + (x * factor), y: y))
            path.addLine(to: CGPoint(x: dx + (x * factor), y: y - postHeight  + stepHeight))
            
            // Embed Type .none
            if flight.ufpEmbType == .none {
                path.move(to: CGPoint(x: dx + (x * factor) - factor, y: y))
                path.addLine(to: CGPoint(x: dx + x * factor + factor, y: y))
            }
        }
        
        // TOP RAIL
        if flight.ufpPosts.count > 0  {
            let totalx = flight.ufpPosts.reduce(0) { partialResult, post in
                partialResult + post.dDistance
            }
            
            path.move(to: CGPoint(x: dx , y: y - postHeight + stepHeight))
            path.addLine(to: CGPoint(x: dx + totalx * factor, y: y - postHeight + stepHeight))
            
        }
        
        return path
    }
}

struct LowerFlatStick: Shape {
    
    let width : Double
    let height : Double
    let flight: Flight
    
    let factor : Double
    let postHeight : Double
    
    let riser = 7.5
    func path(in rect: CGRect) -> Path {
        let lFlat = flight.lFlat * factor
        
        let stepHeight = riser * factor
        
        var path = Path()
        
        var x = 0.0
        let y = height - stepHeight + factor * 2
        for post in flight.lfpPosts {
            x += post.dDistance
            path.move(to: CGPoint(x: lFlat - (x * factor) - factor, y: y))
            path.addLine(to: CGPoint(x: lFlat - (x * factor) - factor, y: y - postHeight ))
            
            // Embed Type .none
            if flight.lfpEmbType == .none {
                path.move(to: CGPoint(x: lFlat - (x * factor)  - (2 * factor), y: y))
                path.addLine(to: CGPoint(x: lFlat - x * factor , y: y))
            }
        }
        
        // TOP RAIL
        if flight.lfpPosts.count > 0 {
            let totalx = flight.lfpPosts.reduce(0) { partialResult, post in
                partialResult + post.dDistance
            }
            
            path.move(to: CGPoint(x: lFlat - (totalx * factor) - factor, y: y - postHeight))
            path.addLine(to: CGPoint(x: lFlat - factor, y: y - postHeight))
        }
        
        return path
    }
}

struct BalusterStick: Shape {
    //let numberOfSteps = 5
    
    let width : Double
    let height : Double
    let flight: Flight
    let factor : Double
    let postHeight : Double
    // local
    let riser = 7.5
    func path (in rect: CGRect) -> Path{
        
        let stepHeight = riser * factor
        let stepWidth = 12.0 * factor
        
        var x = 0.0
        var y = 0.0
        
        let lFlat = flight.lFlat * factor
        
        //let dx = 12 * factor
        var path = Path()
        for baluster in flight.balusters {
            let distance = baluster.dDistanceFirstNose
            let step = Int(round(distance / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1
            
            x = lFlat + stepWidth * CGFloat(step)
            y = height - stepHeight - stepHeight * CGFloat(step) + 2 * factor
            
            path.move(to: CGPoint(x: x - stepWidth / 2, y: y ))
            
            path.addLine(to: CGPoint(x: x - stepWidth / 2, y: y - postHeight + stepHeight - 3.75 * factor))
            
            if flight.balusterEmbType == .none {
                path.move(to: CGPoint(x: x - stepWidth/2 - factor, y: y ))
                path.addLine(to: CGPoint(x: x - stepWidth / 2 + factor, y: y ))
            }
        }
        
        // TOP RAIL
        if flight.lfpPosts.count > 0 || flight.bottomCrotch.exist && flight.bottomCrotch.hasPost {
            path.move(to: CGPoint(x: lFlat - factor, y: height - stepHeight - postHeight + 2 * factor))
        } else {
            if flight.balusters.count > 0 {
                let d1 = flight.balusters[0].dDistanceFirstNose
                let first_step = Int(round(d1 / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1
                path.move(to: CGPoint(x: lFlat + stepWidth * Double(first_step) - stepWidth / 2,
                                      y: height - ((Double(first_step)) * stepHeight) - postHeight - 2 * factor))
            }
        }
        
        if flight.ufpPosts.count > 0 || flight.topCrotch.exist && flight.topCrotch.hasPost {
            path.addLine(to: CGPoint(x: lFlat + stepWidth * Double(flight.numberOfSteps - 1) - factor,
                                     y: height - stepHeight - Double(flight.numberOfSteps - 1) * stepHeight - postHeight + 2 * factor))
        } else {
            if flight.balusters.count > 0 {
                let d2 = flight.balusters.last!.dDistanceFirstNose
                let last_step  = Double(Int(round(d2 / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1)
                path.addLine(to: CGPoint(x: x - stepWidth / 2 , y: height - (last_step * stepHeight) - postHeight - 2 * factor))
            }
        }
        
        return path
    }
}

struct BottomCrotchStick : Shape {
    
    let height : Double
    let flight : Flight
    let postHeight : Double
    let factor : Double
    
    let riser = 7.5
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let stepHeight = riser * factor
        //let lFlat = lower_flat * factor
        
        path.move(to: CGPoint(x: flight.lFlat * factor - flight.bottomCrotch.dDistance * factor,    y: height - stepHeight))
        path.addLine(to: CGPoint(x: flight.lFlat * factor - flight.bottomCrotch.dDistance * factor, y: height - stepHeight - postHeight + factor * 2))
        path.addLine(to: CGPoint(x: flight.lFlat * factor -  factor, y: height - stepHeight - postHeight + factor * 2))
        
        // Embed Type .none
        //        if embType == .none{
        //            path.move(to: CGPoint(x: lFlat - distance * factor  -  factor, y: height - stepHeight + factor * 2))
        //            path.addLine(to: CGPoint(x: lFlat - distance * factor  +  factor, y: height - stepHeight + factor * 2))
        //        } assuming crotch does not embedded
        
        return path
    }
}

struct TopCrotchStick : Shape {
    
    let height : Double
    let flight : Flight
    let factor : Double
    let postHeight : Double
    
    let riser = 7.5
    
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let stepHeight = riser * factor
        //let lFlat = flight.lFlat * factor
        
        let dx = flight.lFlat * factor + (Double(flight.numberOfSteps - 1) * 12.0 * factor) - factor
        let dy = height - stepHeight  - Double(flight.numberOfSteps) * stepHeight
        
        
        //path.move(to: CGPoint(x: lFlat - distance * factor, y: height - stepHeight + factor * 2))
        path.move(to: CGPoint(x: dx + flight.topCrotch.dDistance * factor, y: dy ))
        path.addLine(to: CGPoint(x: dx + flight.topCrotch.dDistance * factor, y: dy - postHeight + stepHeight + factor * 2))
        path.addLine(to: CGPoint(x: dx , y: dy - postHeight + stepHeight + factor * 2))
        
        
        //        // Embed Type .none
        //        if embType == .none{
        //            path.move(to: CGPoint(x: lFlat - distance * factor  -  factor, y: height - stepHeight + factor * 2))
        //            path.addLine(to: CGPoint(x: lFlat - distance * factor  +  factor, y: height - stepHeight + factor * 2))
        //        } assuming crotch does not embedded
        
        return path
    }
}
