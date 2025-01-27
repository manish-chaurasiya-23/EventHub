//
//  CommnunityVM.swift
//  EventHub
//
//  Created by Manish Kumar on 26/01/25.
//

import SwiftUI
import CoreData
import PhotosUI


class CommnunityVM: ObservableObject {
    
    private let context: NSManagedObjectContext
    @Published var bannerImage: UIImage?
    @Published var imageData: Data?
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var isImageUploaded: Bool = false
    @Published var communityName: String = ""
    @Published  var showAlert = false
    @Published  var alertMessage = ""

    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveData() {
        
        let newCommunity = Community(context: context)
        newCommunity.logoImage = imageData
        newCommunity.communityName = communityName
        do {
            try context.save()
            print("Data saved successfully!")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func validateFields() -> Bool {
        if communityName.isEmpty {
            alertMessage = "Coomunity Name title is required."
            return false
        }
        return true
    }
}
