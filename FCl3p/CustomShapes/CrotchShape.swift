//
//  CrotchShape.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation


import SwiftUI

struct BottomCrotch: Shape {
    let height : Double
    let distance : Double
    let lower_flat : Double
    let factor : Double
    
    let riser = 7.5
    
    func path (in rect: CGRect) -> Path {
        
        var path = Path()
        
        let stepHeight = riser * factor
        let lFlat = lower_flat * factor
        
        path.move(to: CGPoint(x: 0, y: height - stepHeight))
        path.addLine(to: CGPoint(x: lFlat - distance * factor, y: height - stepHeight))
        path.addLine(to: CGPoint(x: lFlat - distance * factor, y: height + (factor * 4)))
        path.addLine(to: CGPoint(x: 0, y: height + (factor * 4)))
        path.addLine(to: CGPoint(x: 0, y: height - stepHeight))
        
        return path
    }
}


struct TopCrotch: Shape {
    let height : Double
    let flight : Flight
    
    let factor : Double
    
    // local
    let riser = 7.5
    
    func path (in rect: CGRect) -> Path {
        
        var path = Path()
        
        let stepHeight = riser * factor
        
        let dx = flight.lFlat * factor + (Double(flight.numberOfSteps - 1) * 12.0 * factor) - factor
        let dy = height - Double(flight.numberOfSteps + 1) * stepHeight
        
        path.move(to: CGPoint(x: dx + flight.topCrotch.dDistance * factor, y: dy))
        path.addLine(to: CGPoint(x: dx + (flight.uFlat * factor) + factor, y: dy ))
        path.addLine(to: CGPoint(x: dx + (flight.uFlat * factor) + factor, y: dy + stepHeight + (factor * 4)))
        path.addLine(to: CGPoint(x: dx + flight.topCrotch.dDistance * factor, y: dy + stepHeight + (factor * 4)))
        path.addLine(to: CGPoint(x: dx + flight.topCrotch.dDistance * factor, y: dy))
        
        return path
    }
}

