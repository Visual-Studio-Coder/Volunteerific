//
//  VolunteerHoursLoggerApp.swift
//  VolunteerHoursLogger
//
//  Created by Vaibhav Satishkumar on 6/24/23.
//

import SwiftUI

@main
struct VolunteerHoursLoggerApp: App {
    
	@StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            //ContentView()
			ContentView()
				.environment(\.managedObjectContext, dataController.container.viewContext)
			
    
        }
    }
}
