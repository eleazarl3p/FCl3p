//
//  FlightListView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import SwiftUI

struct FlightListView: View {
    @Environment(\.modelContext) var mc
    @Bindable var stair : Stair
    
    @State private var showNewFlight = false
    
    var sortedFlight : [Flight] {
        stair.flights.sorted(by: { a, b in
            a.dateCreated > b.dateCreated
        })
    }
    
    var body: some View {
        List {
            Section("FLIGHTS") {
                ForEach(sortedFlight) { flight in
                    NavigationLink(value: flight) {
                        HStack {
                            Button(action: {
                                stair.add(flight.copy())
                            }, label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }).buttonStyle(BorderlessButtonStyle())
                            Spacer()
                            
                            Item(name: flight.name, dateCreated: flight.dateCreated)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    stair.flights.remove(atOffsets: indexSet)
                })
            }
        }
        .navigationTitle($stair.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Flight.self, destination: { flight in
            FlightTabView(flight: flight)
        })
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showNewFlight.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showNewFlight, content: {
            NavigationStack {
                NewFlight(stair: stair)
            }
            .presentationDetents([.medium])
        })
    }
}

