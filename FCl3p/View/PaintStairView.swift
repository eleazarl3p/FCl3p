//
//  PaintStairView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import SwiftUI

struct PaintStairView: View {
    
    var flight : Flight
    
    let labels = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    let w = 30.0
    let h = 50.0
    
    let stickSize = 6.0
    let riser = 7.5
    
    var body: some View {
        
        VStack {
            GeometryReader { geo in
                
                let factor = min((geo.size.height - h) / (Double(flight.numberOfSteps)  * riser + 40), ((geo.size.width - w) / ((Double(flight.numberOfSteps) * 12 ) + flight.lFlat + flight.uFlat)))
                let postHeight = 36 * factor
                let labelHeight = 26 * factor
                
                ZStack {
                    Staircase(width: geo.size.width - w,
                              height: geo.size.height - h,
                              flight : flight,
                              factor: factor)
                    .stroke(.colorStairBorder, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                    .background(Staircase(width: geo.size.width - w,
                                          height: geo.size.height - h,
                                          flight : flight,
                                          factor: factor)
                        .fill(.colorStair))
                    .padding()
                    
                    // LFP
                    LfpView(width: geo.size.width - w,
                            height: geo.size.height - h,
                            flight: flight,
                            postHeight: postHeight,
                            factor: factor,
                            stickSize: stickSize,
                            labelHeight: labelHeight)
                    
                    // BALUSTER
                    BalusterView(width: geo.size.width - w,
                                 height: geo.size.height - h,
                                 flight: flight,
                                 postHeight: postHeight,
                                 factor: factor,
                                 stickSize: stickSize,
                                 numberOfSteps: flight.numberOfSteps)
                    
                    // UFP
                    UfpView(width: geo.size.width - w,
                            height: geo.size.height - h,
                            flight: flight,
                            postHeight: postHeight,
                            factor: factor,
                            stickSize: stickSize,
                            numberOfSteps: flight.numberOfSteps,
                            labelHeight: labelHeight)
                    
                    //Bottom Crotch
                    if flight.bottomCrotch.exist {
                        if flight.bottomCrotch.hasPost {
                            BottomCrotchStick(height: geo.size.height - h,
                                              flight: flight,
                                              postHeight: postHeight,
                                              factor: factor
                            ).stroke(.colorStick,
                                     style: StrokeStyle(lineWidth: stickSize,
                                                        lineCap: .round,
                                                        lineJoin: .round)
                            )
                            .padding()
                        }
                        
                        BottomCrotch(height: geo.size.height - h,
                                     distance: flight.bottomCrotch.dDistance,
                                     lower_flat: flight.lFlat,
                                     factor: factor)
                        .stroke(.colorCrotch, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .background(BottomCrotch(height: geo.size.height - h,
                                                 distance: flight.bottomCrotch.dDistance,
                                                 lower_flat: flight.lFlat,
                                                 factor: factor)
                            .fill(.colorCrotch))
                        .padding()
                    }
                    
                    // Top Crotch
                    if flight.topCrotch.exist {
                        if flight.topCrotch.hasPost {
                            TopCrotchStick(height:  geo.size.height - h,
                                           flight: flight,
                                           factor: factor,
                                           postHeight: postHeight)
                            .stroke(.colorStick, style: StrokeStyle(lineWidth: stickSize, lineCap: .round, lineJoin: .round))
                            .padding()
                        }
                        
                        TopCrotch(height: geo.size.height - h,
                                  flight: flight,
                                  factor: factor)
                        .stroke(.colorCrotch, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .background(TopCrotch(height: geo.size.height - h,
                                              flight: flight,
                                              factor: factor)
                            .fill(.colorCrotch))
                        .padding()
                    }
                }
            }
        }//.background(.red)
        .padding(.bottom, -20)
    }
}

struct PostLabel: View {
    let name : String
    var color = Color(red: 0.2745, green: 0.5098, blue: 0.6627)
    var width = 20.0
    var height = 20.0
    var body: some View {
        Text(name)
            .font(.caption)
            .frame(width: width, height: height, alignment: .center)
            .foregroundColor(.white)
            .background(color)
            .clipShape(Circle())
    }
}

struct LfpView : View {
    let width : Double
    let height: Double
    let flight: Flight
    let postHeight : Double
    let factor : Double
    let stickSize : Double
    let labelHeight : Double
    
    var body: some View {
        ZStack {
            //LFP
            LowerFlatStick(width: width,
                           height: height,
                           flight: flight,
                           factor: factor,
                           postHeight: postHeight)
            .stroke(.colorStick, style: StrokeStyle(lineWidth: stickSize, lineCap: .round, lineJoin: .round))
            .padding()
            
            // Lower Flat Embedded Type
            if flight.lfpEmbType != .none {
                LowerFlatEmbed(width: width,
                               height: height,
                               flight: flight,
                               factor: factor)
                .fill(flight.lfpEmbType == .plate ? .colorPlate : .colorSleeve)
                .padding()
            }
            
            
            // lfp
            let cumulativeBottomDistances = flight.lfpPosts.reduce(into: [Double]()) { (result, object) in
                let lastDistance = result.last ?? 0.0
                result.append(lastDistance + object.dDistance)
            }
            
            ForEach(Array(flight.lfpPosts.enumerated()), id: \.1.id) { index, post in
                PostLabel(name: post.name)
                    .position(CGPoint(x: flight.lFlat * factor + 12 - cumulativeBottomDistances[index] * factor, y: height - labelHeight))
            }
        }
    }
}

struct UfpView : View {
    let width : Double
    let height: Double
    let flight: Flight
    let postHeight : Double
    let factor : Double
    let stickSize : Double
    let numberOfSteps: Int
    let labelHeight : Double
    
    var body: some View {
        ZStack {
            // UFP
            UpperFlatStick(width: width,
                           height: height,
                           flight: flight,
                           factor: factor,
                           postHeight: postHeight)
            .stroke(.colorStick, style: StrokeStyle(lineWidth: stickSize, lineCap: .round, lineJoin: .round))
            .padding()
            
            // UPPER Flat embedded Type
            if flight.ufpEmbType != .none {
                UpperFlatEmbed(width: width,
                               height: height,
                               flight: flight,
                               factor: factor)
                .fill(flight.ufpEmbType == .plate ? .colorPlate : .colorSleeve)
                .padding()
            }
            
            
            // ufp
            let cumulativeTopDistances = flight.ufpPosts.reduce(into: [Double]()) { (result, object) in
                let lastDistance = result.last ?? 0.0
                result.append(lastDistance + object.dDistance)
            }
            
            let dx = flight.lFlat * factor + (Double(numberOfSteps - 1) * 12.0 * factor)
            let dy = height - Double(numberOfSteps - 1) * 7.5 * factor
            ForEach(Array(flight.ufpPosts.enumerated()), id: \.1.id) { index, post in
                PostLabel(name: post.name)
                    .position(CGPoint(x: dx + 12 + cumulativeTopDistances[index] * factor, y: dy - labelHeight))
            }
        }
    }
}

struct BalusterView : View {
    let width : Double
    let height: Double
    let flight: Flight
    let postHeight : Double
    let factor : Double
    let stickSize : Double
    let numberOfSteps : Int
    
    var stepHeight : Double { 7.5 * factor }
    var stepWidth : Double { 12 * factor }
    var body: some View {
        ZStack {
            // BALUSTER
            BalusterStick(width: width,
                          height: height,
                          flight: flight,
                          factor: factor,
                          postHeight: postHeight)
            .stroke(.colorStick, style: StrokeStyle(lineWidth: stickSize, lineCap: .round, lineJoin: .round))
            .padding()
            
            // Baluster Embedded Type
            if flight.balusterEmbType != .none {
                BalusterEmbed(width: width,
                              height: height,
                              flight: flight,
                              factor: factor)
                .fill(flight.balusterEmbType == .plate ? .colorPlate : .colorSleeve)
                .padding()
            }
            
            // Label
            ForEach(0..<numberOfSteps, id: \.self) { i in
                PostLabel(name: "\(i + 1)", color: .colorSleeve)
                    .position(
                        CGPoint(
                            x: flight.lFlat * factor + stepWidth * CGFloat(i) + 5,
                            y: height - stepHeight * CGFloat(i + 1) - 10
                        )
                    )
                
            }
            
            
            Dimensions(width: width,
                       height: height,
                       flight: flight,
                       factor: factor,
                       postHeight: postHeight)
            .stroke(.red)
            .padding()
            
            let firstNose_x = (flight.lFlat - 1) * factor
            let firstNose_y = height - stepHeight * 2
            
            
            ForEach(flight.balusters) { baluster in
                let distance = baluster.dDistanceFirstNose
                let step = Int(round(distance / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1
                
                Text(baluster.distanceFirstNose)
                    .frame(height: 20.0, alignment: .center)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background(.red)
                    .position(CGPoint(x: firstNose_x , y: firstNose_y - stepHeight * Double(step + 1)))
                    .offset(x: (Double(step) * stepWidth) / 2, y: 15)
                
            }
        }
    }
}

struct Dimensions : Shape {
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
        
        var path = Path()
        
        let firstNose_x = (flight.lFlat - 1)  * factor
        let firstNose_y = height - stepHeight * 2
        var n = 1.0
        for baluster in flight.balusters {
            let distance = baluster.dDistanceFirstNose
            let step = Int(round(distance / sqrt(144 + (flight.dBevel * flight.dBevel)))) + 1
            
            
            path.move(to: CGPoint(x: firstNose_x, y: firstNose_y))
            
            path.addLine(to: CGPoint(x: firstNose_x , y: firstNose_y - stepHeight * Double(step + 1)))
            
            path.addLine(to: CGPoint(x: firstNose_x  + Double(step - 1) * stepWidth,
                                     y: firstNose_y -  stepHeight * Double(step + 1)))
            path.addLine(to: CGPoint(x: firstNose_x  + Double(step - 1) * stepWidth,
                                     y: firstNose_y - riser * factor - stepHeight * Double(step -  2)))
            n += 1
        }
        
        
        return path
    }
}

//#Preview {
//    PaintStairView(flight: DummyData.sampleFlight)
//}
