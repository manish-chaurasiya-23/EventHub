//
//  HomeView.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI
import CoreData

struct EventListingScreen: View {
    
    @StateObject private var viewModel: EventViewModel
        
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: EventViewModel(context: context))
    }
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Delhi NCR")
                        .font(.system(size: 20))
                    Text("Elcome to the Tribe!")
                        .font(.system(size: 16))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
            }
            TestingView(events: $viewModel.events, communities: $viewModel.communities)

        }
        .padding()
    }
}


struct SegmentedView: View {
    @Binding var selection: SegmentItem

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(SegmentItem.allCases, id: \.id) { item in
                    Button(action: {
                        withAnimation {
                            selection = item
                        }
                    }) {
                        VStack(spacing: 0) {
                            Text(item.title())
                                .padding()
                                .font(.headline)
                                .foregroundColor(selection == item ? .blue : .gray)
                                .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(selection == item ? Color.blue : Color.clear)
                                .frame(height: 2)
                        }
                        .frame(minHeight: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(minHeight: 0)
    }
}



enum SegmentItem: String, CaseIterable {
    case events
    case communities

    var id: String {
        rawValue
    }

    func title() -> String {
        switch self {
        case .events:
            return "Events"
        case .communities:
            return "Communities"
        }
    }
}

struct TestingView: View {
    
    @State private var segmentSelection: SegmentItem = .events
    @Binding var events: [Event]
    @Binding var communities: [Community]
    
    var body: some View {
        VStack(spacing: 0) {
            
            SegmentedView(selection: $segmentSelection)
                .padding(.bottom, 10)
            
            if segmentSelection == .events {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 16
                    ) {
                        ForEach(events, id: \.self) { event in
                            CardView(event: event)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 0)
                }
                .padding(.top, 0)
            } else {
                ScrollView {
                    VStack {
                        ForEach($communities, id: \.self) { $community in
                            HStack {
                                if let data = community.logoImage, let image = UIImage(data: data) {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                        )
                                } else {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)
                                }
                                Text(community.communityName ?? "")
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        Spacer(minLength: 0)
                    }
                }
                .padding(.top, 0)
            }
            Spacer()
        }
    }
}

struct CardView: View {
    
    let event: Event
    
    var body: some View {
        VStack {
            VStack {
                if let data = event.bannerImage {
                    if let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                    }
                Text(event.eventCommunity ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(event.eventTitle ?? "By Bhag Club")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text(getEventDate(event.eventStartDate))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
               Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.white)
                    }
                Text(event.locationFirstLine ?? "Nehru park")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .padding()
        .cornerRadius(8)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, minHeight: 100)
    }
    
    func getEventDate(_ date: Date?) -> String {
        guard let startDate = date else { return "No Date" }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        if calendar.isDate(startDate, inSameDayAs: today) {
            return "Today, \(formatDate(startDate))"
        } else if calendar.isDate(startDate, inSameDayAs: tomorrow) {
            return "Tomorrow, \(formatDate(startDate))"
        } else {
            return formatDate(startDate, includeDate: true)
        }
    }

    func formatDate(_ date: Date, includeDate: Bool = false) -> String {
        let formatter = DateFormatter()
        
        if includeDate {
            formatter.dateFormat = "dd MMM h:mm a"
        } else {
            formatter.dateFormat = "h:mm a"
        }
        return formatter.string(from: date)
    }

}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        EventListingScreen(context: context)
    }
}



