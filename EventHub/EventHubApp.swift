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
            NavigationView {
                VStack(spacing: 20) {
                    NavigationLink(destination: CreateNewEventView(context: persistenceController.container.viewContext)) {
                        Text("Create Event View")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
//                    NavigationLink(destination: CreateCommunityView(context: persistenceController.container.viewContext)) {
//                        Text("Create Community View")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }

                    NavigationLink(destination: EventListingScreen(context: persistenceController.container.viewContext)) {
                        Text("Event Listing Screen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .navigationTitle("EventHub App")
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
