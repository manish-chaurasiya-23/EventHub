//
//  EventsVM.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//

import CoreData
import SwiftUI
import CoreLocation
import PhotosUI
import MapKit

class EventViewModel: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var bannerImage: UIImage?
    @Published var imageData: Data?
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var selectedCommunity: String?
    @Published var eventTitleText: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().addingTimeInterval(3600)
    @Published var descriptionText: String = ""
    
    @Published var isImageUploaded: Bool = false
    
    @Published var selectedLocation: CLLocationCoordinate2D?
    @Published var locationFirstLine: String? = nil
    @Published var locationSecondLine: String? = nil {
        didSet {
            guard let coordinate = selectedLocation else { return }
            fetchLocationDetails(for: coordinate)
        }
    }
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var isMapPresented = false

    @Published var events: [Event] = []
    @Published var communities: [Community] = []
    
    @Published  var showAlert = false
    @Published  var alertMessage = ""

        
    init(context: NSManagedObjectContext) {
        self.context = context
        Task {
            await fetchCommunities()
            await fetchEvents()
        }
    }
    
    @MainActor
    func fetchEvents() async {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Add sort descriptor for eventStartDate in ascending order
        let sortDescriptor = NSSortDescriptor(key: "eventStartDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create a predicate to fetch only events with eventStartDate in the future
        let now = Date()
        fetchRequest.predicate = NSPredicate(format: "eventStartDate >= %@", now as NSDate)
        
        do {
            let fetchedEvents = try await context.perform {
                try self.context.fetch(fetchRequest)
            }
            events = fetchedEvents // Update the `events` property if it's @Published or a similar property
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        
        let newEvent = Event(context: context)
        newEvent.id = UUID()
        newEvent.bannerImage = imageData
        newEvent.eventCommunity = selectedCommunity
        newEvent.eventTitle = eventTitleText
        newEvent.eventStartDate = startDate
        newEvent.eventEndDate = endDate
        newEvent.locationFirstLine = locationFirstLine
        newEvent.locationSecondLine = locationSecondLine

        do {
            try context.save()
            print("Data saved successfully!")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func fetchLocationDetails(for coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                self?.locationFirstLine = "Unable to fetch location"
                self?.locationSecondLine = "Error occurred"
                return
            }
            
            guard let placemark = placemarks?.first else {
                self?.locationFirstLine = "No details found"
                self?.locationSecondLine = ""
                return
            }
            
            let name = placemark.name ?? "Unknown Location"
            let city = placemark.locality ?? "Unknown City"
            let state = placemark.administrativeArea ?? "Unknown State"
            let country = placemark.country ?? "Unknown Country"
            
            self?.locationFirstLine = "\(name), \(city)"
            self?.locationSecondLine = "\(state), \(country)"
        }
    }
    
    func validateFields() -> Bool {
        if eventTitleText.isEmpty {
            alertMessage = "Event title is required."
            return false
        }
        
        if ((locationFirstLine?.isEmpty) != nil) {
            alertMessage = "Location first line is required."
            return false
        }
        
        if ((selectedCommunity?.isEmpty) != nil) {
            alertMessage = "Community selection is required."
            return false
        }
        
        if imageData == nil {
            alertMessage = "Banner image is required."
            return false
        }
        
        if startDate >= endDate {
            alertMessage = "Start date must be before the end date."
            return false
        }
        return true
    }
    
    @MainActor
    func fetchCommunities() async {
        let fetchRequest: NSFetchRequest<Community> = Community.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "communityName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedCommunities = try await context.perform {
                try self.context.fetch(fetchRequest)
            }
            communities = fetchedCommunities // Update the published property
        } catch {
            alertMessage = "Error fetching communities: \(error.localizedDescription)"
            showAlert = true
        }
    }

}

