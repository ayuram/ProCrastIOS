//
//  Simulation.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/7/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import Foundation
import EventKit
struct Simulation: View {
    @EnvironmentObject var activities: Activities
//    var activities: Activities = Activities()
//    init(){
//        activities.activities = [Activity("hello"), Activity("ok"), Activity("ok"), Activity("ok"), Activity("ok"), Activity("ok")]
//    }
    var body: some View{
        VStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("accent"), Color(.random())]), startPoint: .leading, endPoint: .trailing)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(activities.activities){ activity in
                            
                            GeometryReader { geometry in
                                ActivityCard(activity)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX) / -20), axis: (x: 0, y: 10.0, z: 0))
                                    .shadow(radius: 5)
                            }.frame(width:110, height: 180)
                            
                        }
                    }
                }
            }.frame(height: 180, alignment: .trailing)
            
            ThemedButton(text: "Move To Calendar"){
                var components = DateComponents()
                components.hour = 8
                components.minute = 0
                let date = Calendar.current.date(from: components) ?? Date()
                self.activities.activities.map { self.addEventToCalendar(title: $0.name, description: $0.name , startDate: Date(timeIntervalSinceNow: TimeInterval()), timespan: TimeInterval())
                }
            }
        }
        //        Button("click me"){
        //            self.activities.activities.map { self.addEventToCalendar(title: $0.name, description: $0.name , startDate: Date(timeIntervalSinceNow: TimeInterval()), timespan: TimeInterval())}
        //        }
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date, timespan: TimeInterval, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.isAllDay = false

                event.startDate = startDate
                event.endDate = startDate.addingTimeInterval(timespan)
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
}

struct Simulation_Previews: PreviewProvider {
    static var previews: some View {
        Simulation()
    }
}
