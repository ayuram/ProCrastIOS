//
//  Simulation.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import Foundation
import EventKit

struct Simulation: View {
    @EnvironmentObject var activities: Data
    @State var due: Date = Date()
    @State var show = false
    @State var cards: [Activity] = []
    @State var new: UUID? = .none
    @State var start = ""
    let color = Color(.random())
    //@ObservedObject var activities: Activities = Activities()
//    init(){
//        activities.activities = [Activity("hello"), Activity("ok"), Activity("ok"), Activity("ok"), Activity("ok"), Activity("ok")]
//    }
    var body: some View{
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("accent"), color]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Text("Start Time ")
                        .font(.title)
                        .bold()
                    Text(start)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("accent"))
                }
                .padding()
                .background(Color("background"))
                .clipShape(Capsule())
                .shadow(radius: 5)
                Spacer()
                
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(cards){ activity in
                                    GeometryReader { geometry in
                                        ActivityCard(activity)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX) / -10), axis: (x: 0, y: 10.0, z: 0.0))
                                                .shadow(radius: 5)
                                    }
                                    .frame(width: 130, height: 250, alignment: .center)
                                }
                                Text("")
                                    .frame(width: 200)
                            }
                        }.frame(height: 250)
                    
                    VStack{
                        HStack{
                            Spacer()
                            ThemedButton(text: "+", width: 35, height: 35){
                                if(activities.activities.count != 0){
                                    new = activities.activities[0].id
                                }
                                show.toggle()
                            }
                            .sheet(isPresented: $show, content: {
                                NavigationView{
                                    Picker("Activity", selection: $new){
                                        ForEach(activities.activities){ activity in
                                            Text(activity.name).tag(activity.id)
                                        }
                                    }
                                    .navigationBarTitle("Pick an Activity")
                                    .navigationBarItems(leading: Button("Cancel"){
                                        new = .none
                                        show = false
                                    }, trailing: Button("Save"){
                                        if(new != .none){
                                            cards.append(
                                                activities.activities
                                                    .first(where: {$0.id == new}) ?? Activity("")
                                            )
                                        }
                                        new = .none
                                        show = false
                                    })
                                }
                            })
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            ThemedButton(text: "-", buttonColor: .red, width: 35, height: 35){
                                cards.removeLast()
                            }
                        }
                    }.padding(5)
                }.frame(height: 250, alignment: .trailing)
                DatePicker("Sleep Deadline", selection: $due, in: Date()... , displayedComponents: .hourAndMinute)
                        .frame(width: 300, height: 50)
                        .background(Color("background"))
                        .clipShape(Capsule())
                //.frame(width: 300, height: 50)
                //.background(Color("background"))
                //.clipShape(Capsule())
                //.shadow(radius: 5)
                
                Spacer()
    //            ThemedButton(text: "Calculate"){
    //                var components = DateComponents()
    //                components.hour = 8
    //                components.minute = 0
    //                let date = Calendar.current.date(from: components) ?? Date()
    //                self.activities.activities.map { self.addEventToCalendar(title: $0.name, description: $0.name , startDate: Date(timeIntervalSinceNow: TimeInterval()), timespan: TimeInterval())
    //                }
    //            }
            }
            }
            .navigationBarItems(trailing: ThemedButton(text: "Calculate", height: 50){
                startTime()
            })
            .navigationBarTitle("Dashboard")
        }
        //        Button("click me"){
        //            self.activities.activities.map { self.addEventToCalendar(title: $0.name, description: $0.name , startDate: Date(timeIntervalSinceNow: TimeInterval()), timespan: TimeInterval())}
        //        }
    }
    func startTime() {
        let num = cards.reduce(0.0){ $0 + ($1.avgTime() ?? 0) * Double($1.reps)}
        let date = due.addingTimeInterval(TimeInterval(-Int(num) * 60))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        start = formatter.string(from: date)
    }
}


struct Simulation_Previews: PreviewProvider {
    static var previews: some View {
        Simulation()
            .environmentObject(Data())
    }
}
