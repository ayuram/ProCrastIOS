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
import SwiftUICharts
struct Simulation: View {
    @EnvironmentObject var activities: Data
    @State var due: Date = Date()
    @State var show = false
    @State var cards: [Activity] = []
    @State var new: UUID? = .none
    @State var start = ""
    @State var hoursSlept = 8
    let color = Color(.random())
    var body: some View{
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("accent"), color]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Text("Start Time")
                        .font(.title)
                        .bold()
                    if(start != ""){
                        Text(" \(start)")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("accent"))
                    }
                }.animation(.default)
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
                                alertSheet()
                            })
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            ThemedButton(text: "-", buttonColor: .red, width: 35, height: 35){
                                if(cards.count > 0){
                                    cards.removeLast()
                                }
                            }
                        }
                    }.padding(5)
                }.frame(height: 250, alignment: .trailing)
                VStack{
                    DatePicker("Sleep Deadline", selection: $due, in: Date()... , displayedComponents: .hourAndMinute)
                    Stepper(value: $hoursSlept, in: 3 ... 12) {
                        Text("\(hoursSlept) Hours Slept")
                    }
                }
                .padding()
                .frame(width: 300, height: 100)
                .background(Color("background"))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 12)
                
                Spacer()
            }
            }
//            .sheet(isPresented: $otherSheet, content: {
//                alertSheet()
//            })
            .navigationBarItems(trailing: ThemedButton(text: "Calculate", height: 45){
                startTime()
            })
            .navigationBarTitle("Dashboard")
        }
    }
    func alertSheet() -> some View{
//        if(otherSheet){
//            return AnyView(NavigationView{
//                VStack{
//                DatePicker("Sleep Deadline", selection: $due, in: Date()... , displayedComponents: .hourAndMinute)
//                Stepper(value: $hoursSlept, in: 3 ... 12) {
//                    Text("\(hoursSlept) Hours Slept")
//                }
//                    Spacer()
//                    ThemedButton(text: "Let's Go", width: 200){
//                        otherSheet.toggle()
//                    }
//            }
//                .navigationBarTitle("Before You Start ...")
//            .padding()
//            .frame(width: 300, height: 200)
//            .background(Color("background"))
//            .clipShape(RoundedRectangle(cornerRadius: 25))
//            .shadow(radius: 12)
//
//            })
//        }
        
           return AnyView(NavigationView{
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
            })
        
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
