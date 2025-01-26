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
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveData() {
        do {
            try context.save()
            print("Data saved successfully!")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
}
