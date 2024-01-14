//
//  StaircaseShape.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import Foundation
import SwiftUI

struct Staircase: Shape {
    
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
        
        let lFlat = flight.lFlat * factor
        let uFlat = flight.uFlat * factor
        
        var x = 0.0
        var y = 0.0
        
        path.move(to: CGPoint(x: 0, y: height - stepHeight))
        path.addLine(to: CGPoint(x: lFlat, y: height - stepHeight))
        
        for i in 0..<flight.numberOfSteps {
            x = lFlat + stepWidth * CGFloat(i)
            y = height - stepHeight * CGFloat(i+1)
            
            path.addLine(to: CGPoint(x: x, y: y))
            
            path.addLine(to: CGPoint(x: x - factor, y: y - stepHeight))
            path.addLine(to: CGPoint(x: x + stepWidth, y: y - stepHeight))
        }
        //x += stepWidth
        y -= stepHeight
        path.addLine(to: CGPoint(x: x + uFlat, y: y ))
        path.addLine(to: CGPoint(x: x + uFlat, y: y + stepHeight + (factor * 4)))
        path.addLine(to: CGPoint(x: x - factor + stepWidth, y: y + stepHeight + (factor * 4)))
        path.addLine(to: CGPoint(x: lFlat, y: height + (factor * 4)))
        path.addLine(to: CGPoint(x: 0, y: height + (factor * 4)))
        path.addLine(to: CGPoint(x: 0, y: height - stepHeight))
        
        return path
    }
}

