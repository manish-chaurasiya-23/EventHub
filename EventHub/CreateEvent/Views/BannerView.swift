//
//  BannerView.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//
import SwiftUI
import PhotosUI

struct BannerView: View {
    @Binding var bannerImage: UIImage?
    @Binding var imageData: Data?
    @Binding var photoPickerItem: PhotosPickerItem?
    @Binding var isImageUploaded: Bool

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing)
            VStack {
                if let bannerImage = bannerImage {
                    Image(uiImage: bannerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "heart.fill")
                        .padding(.top, 100)

                    Spacer()

                    PhotosPicker(selection: $photoPickerItem, matching: .any(of: [.images])) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Add Photo")
                        }
                        .foregroundColor(.black)
                        .background(.white)
                    }
                    .onChange(of: photoPickerItem) { newItem in
                        Task {
                            if let photoPickerItem = newItem,
                               let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                imageData = data
                                bannerImage = image
                                isImageUploaded = true
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 250)
        }
    }
}
