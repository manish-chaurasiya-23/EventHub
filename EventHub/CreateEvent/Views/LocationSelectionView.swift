//
//  LocationSelectionView.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationSelectionView: View {
    
    @Binding var locationFirstLine: String?
    @Binding var locationSecondLine: String?
    @Binding var isMapPresented: Bool
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion

    var body: some View {
        VStack {
            HStack {
                Circle()
                     .fill(Color.gray)
                     .frame(width: 30, height: 30)
                     .overlay {
                         Image(systemName: "mappin.and.ellipse")
                             .foregroundColor(.white)
                     }
                if let locationFirstLine = locationFirstLine, let locationSecondLine = locationSecondLine {
                    VStack(alignment: .leading) {
                        Text(locationFirstLine)
                            .font(.headline)
                        Text(locationSecondLine)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("Choose Location")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .onTapGesture {
                isMapPresented.toggle()
            }

            if isMapPresented {
                MapView(
                    region: $region,
                    selectedLocation: $selectedLocation,
                    updateLocationDetails: { firstLine, secondLine in
                        self.locationFirstLine = firstLine
                        self.locationSecondLine = secondLine
                    }
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var locationDetails: String?
    
    var updateLocationDetails: (String, String) -> Void

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                .onTapGesture {
                    selectedLocation = region.center
                    if let selectedLocation = selectedLocation {
                        fetchLocationDetails(for: selectedLocation)
                    }
                }
        }
        .frame(height: 300)
    }

    /// Reverse geocoding to fetch city, state, and country.
    private func fetchLocationDetails(for coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                updateLocationDetails("Unable to fetch location", "Error occurred")
                return
            }
            
            guard let placemark = placemarks?.first else {
                updateLocationDetails("No details found", "")
                return
            }
            
            let name = placemark.name ?? "Unknown Location"
            let city = placemark.locality ?? "Unknown City"
            let state = placemark.administrativeArea ?? "Unknown State"
            let country = placemark.country ?? "Unknown Country"
            
            updateLocationDetails("\(name), \(city)", "\(state), \(country)")
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
