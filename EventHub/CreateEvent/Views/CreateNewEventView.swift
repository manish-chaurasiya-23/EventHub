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
import CoreData

struct CreateNewEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: EventViewModel
        
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: EventViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    BannerView(bannerImage: $viewModel.bannerImage, imageData: $viewModel.imageData, photoPickerItem: $viewModel.photoPickerItem, isImageUploaded: $viewModel.isImageUploaded)
                    CommunitySelectionView(selectedOption: $viewModel.selectedCommunity, commuinities: $viewModel.communities)
                    EventTitleView(textInput: $viewModel.eventTitleText)
                    EventDateTimeSection(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                    LocationSelectionView(
                        locationFirstLine: $viewModel.locationFirstLine,
                        locationSecondLine: $viewModel.locationSecondLine,
                                isMapPresented: $viewModel.isMapPresented,
                                selectedLocation: $viewModel.selectedLocation,
                                region: $viewModel.region
                            )
                    DescriptionInputView(description: $viewModel.descriptionText)
                    Button {
                        if !viewModel.validateFields() {
                            viewModel.showAlert = true
                        } else {
                            viewModel.saveData()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label : {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Validation Failed"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationTitle("Create new event")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct CommunitySelectionView: View {
    @Binding var selectedOption: String?
    @Binding var commuinities: [Community]

    var body: some View {
        VStack {
            Text("Select Community")
                .frame(maxWidth: .infinity, alignment: .leading)
            DropDownView(selectedOption: $selectedOption, commuinities: $commuinities)
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
                Circle()
                     .fill(Color.gray)
                     .frame(width: 30, height: 30)
                     .overlay {
                         Image(systemName: "heart.fill")
                             .foregroundColor(.white)
                     }
                VStack(alignment: .leading) {
                    Text("Add Description*")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("We can't wait for you to join us:", text: $description)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                }
                Image(systemName: "chevron.right")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}


struct CreateNewEventView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        CreateNewEventView(context: context)
    }
}

