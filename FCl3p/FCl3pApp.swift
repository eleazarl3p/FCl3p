//
//  FCl3pApp.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import SwiftUI
import SwiftData

@main
struct FCl3pApp: App {
    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .accentColor(Color(.label))
        }
        .modelContainer(for: [Project.self, FlightCrotch.self])
    }
    
//    init () {
//        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//    }
}
