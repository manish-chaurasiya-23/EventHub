//
//  ContentView.swift
//  EventHub
//
//  Created by Manish Kumar on 23/01/25.
//

import SwiftUI
import PhotosUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @State private var isImageUploaded: Bool = false
    @State private var bannerImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @State var selectedOption: String?
    @State private var eventTitleText: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var isMapPresented = false
    @State private var descriptionText: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    BannerView(bannerImage: $bannerImage, photoPickerItem: $photoPickerItem, isImageUploaded: $isImageUploaded)
                    CommunitySelectionView(selectedOption: $selectedOption)
                    EventTitleView(textInput: $eventTitleText)
                    EventDateTimeSection(startDate: $startDate, endDate: $endDate)
                    LocationSelectionView(
                        isMapPresented: $isMapPresented,
                        selectedLocation: $selectedLocation,
                        region: $region
                    )
                    DescriptionInputView(description: $descriptionText)
                }
                .navigationTitle("Create new event")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct CommunitySelectionView: View {
    @Binding var selectedOption: String?

    var body: some View {
        VStack {
            Text("Select Community")
                .frame(maxWidth: .infinity, alignment: .leading)
            DropDownView(selectedOption: $selectedOption)
        }
        .padding()
    }
}


struct EventTitleView: View {
    @Binding var textInput: String

    var body: some View {
        VStack {
            Text("Event Title*")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("", text: $textInput)
                .padding()
                .background(RoundedRectangle(cornerRadius: 40).stroke(Color.gray, lineWidth: 1))
        }
        .padding()
    }
}

struct DescriptionInputView: View {
    @Binding var description: String

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                VStack(alignment: .leading) {
                    Text("Add Description*")
                    TextField("We can't wait for you to join us and be part of our community :)", text: $description)
                        .multilineTextAlignment(.leading)
                }
                Image(systemName: "chevron.right")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

#Preview {
    ContentView()
}
