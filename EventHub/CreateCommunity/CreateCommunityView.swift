//
//  CreateCommunityView.swift
//  EventHub
//
//  Created by Manish Kumar on 26/01/25.
//

import SwiftUI
import PhotosUI
import CoreData


struct CreateCommunityView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: CommnunityVM
        
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: CommnunityVM(context: context))
    }
    var body: some View {
        
        VStack(spacing: 50) {
            VStack(spacing: 50) {
                Text("Select Community Logo")
                BannerView(bannerImage: $viewModel.bannerImage, imageData: $viewModel.imageData, photoPickerItem: $viewModel.photoPickerItem, isImageUploaded: $viewModel.isImageUploaded)
                    .frame(width: 200, height: 200)
            }
            VStack {
                Text("Community Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $viewModel.communityName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 40).stroke(Color.gray, lineWidth: 1))
            }
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
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

