//
//  EventDateTimeSection.swift
//  EventHub
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI

struct EventDateTimeSection: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        VStack {
            EventDateTimePicker(label: "Starts", date: $startDate)
            HStack {
                DashedLine(lineWidth: 1, dash: [5, 5])
                    .frame(width: 1, height: 20)
                    .padding(.horizontal, 30)
                Spacer()
            }
            EventDateTimePicker(label: "Ends", isStart: false, date: $endDate)
        }
        .padding()
    }
}

struct EventDateTimePicker: View {
    
    let label: String
    var isStart: Bool = true
    @Binding var date: Date
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: isStart ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.black)
                Text(label)
                Spacer()
                DatePicker("\(label) Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
        }
    }
}

struct DashedLine: Shape {
    var lineWidth: CGFloat
    var dash: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, dash: dash))
    }
}
