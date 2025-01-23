//
//  EventHubApp.swift
//  EventHub
//
//  Created by Manish Kumar on 23/01/25.
//

import SwiftUI

@main
struct EventHubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
