//
//  FlightTabView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import SwiftUI

struct FlightTabView: View {
    
    @Bindable var flight : Flight
    
    @State var validData : Bool = true
    var body: some View {
        TabView {
            FlightDetailView(flight: flight, lfpPostCount: flight.lfpPosts.count, ufpPostCount: flight.ufpPosts.count, balusterCount: flight.balusters.count, validData: $validData)
                .tabItem {
                    Label("Form", systemImage: "pencil")
                }
            
            if validData {
                
                PaintStairView(flight: flight)
                    .tabItem {
                        Label("Flight", systemImage: "figure.stair.stepper")
                    }
            }
        }
        .navigationTitle($flight.name)
    }
}

//#Preview {
//    FlightTabView()
//}
