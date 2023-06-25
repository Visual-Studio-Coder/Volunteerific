//
//  VolunteerHoursLoggerApp.swift
//  VolunteerHoursLogger
//
//  Created by Vaibhav Satishkumar on 6/24/23.
//

import SwiftUI

@main
struct VolunteerHoursLoggerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
