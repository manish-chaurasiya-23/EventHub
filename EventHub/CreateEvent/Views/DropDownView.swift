//
//  DropDownView.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI

struct DropDownView: View {
    
    @Binding  var selectedOption: String?
    @State private var showDropdown: Bool = false
    let options = ["Sports Club", "Music Band", "Tech Enthusiasts", "Art Community"]
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption ?? "Select an option")
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                    Image(systemName: "arrowtriangle.down")
                        .rotationEffect(.degrees(showDropdown ? 180 : 0))
                        .foregroundColor(.black)
                        .padding()
                }
                .background(RoundedRectangle(cornerRadius: 40).stroke(Color.gray, lineWidth: 1))
            }
            
            // Dropdown
            if showDropdown {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selectedOption = option
                            withAnimation {
                                showDropdown = false
                            }
                        } label: {
                            Text(option)
                                .padding()
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .background(Color.gray)
                .cornerRadius(8)
            }
        }
        .background(Color.white)
    }
}
