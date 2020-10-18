//
//  ActivityView.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/6/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}
extension UIColor {
    static func random() -> UIColor{
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 0.9)
    }
}
extension Double{
    func truncate(_ places: Int) -> Double{
        Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    func int() -> Int{
        Int(self)
    }
}
struct ActivityView: View {
    public let activity: Activity
    let myColor: Color
    @ObservedObject var stopWatch = StopWatch()
    @State var on = true
    @State var due = Date()
    @State var show = false
    init(_ act: Activity){
        activity = act
        myColor = activity.color
        
        due = activity.deadline
    }
    
    var body: some View {
        NavigationView {
                VStack{
                    Spacer()
                    Text(self.stopWatch.stopWatchTime)
                        .font(.custom("courier", size: 70))
                        .frame(width: UIScreen.main.bounds.size.width,
                               height: 80,
                               alignment: .center)
                    HStack{
                        Button("Save"){
                            self.save()
                            withAnimation(.easeIn(duration: 1)){
                                self.on = true
                            }
                        }.disabled(!self.stopWatch.hasStarted)
                        
                        Button("Start"){
                            self.stopWatch.start()
                            withAnimation(.easeIn(duration: 1)){
                                self.on = false
                            }
                        }.disabled(!self.stopWatch.isPaused())
                        
                        Button("Pause"){
                            self.stopWatch.pause()
                        }.disabled(self.stopWatch.isPaused())
                    }.padding()
                    
                    VStack {
                        recentTime()
                        .animation(.easeInOut(duration: 1))
                        .minimumScaleFactor(0.1)
                        HStack{
                            VStack{
                                Text("\(activity.times.max()?.int() ?? 0)")
                                Spacer()
                                Text("\(activity.times.min()?.int() ?? 0)")
                            }
                            LineGraph(activity.times.map{CGFloat($0)}.normalized)
                                .trim(to: on ? 1: 0)
                                .stroke(activity.color, lineWidth: 2)
                                
                                .animation(.easeInOut(duration: 1.5))
                                
                                .border(Color.gray, width: 1)
                        }.padding()
                    }.padding()
                        .sheet(isPresented: $show){
                            NavigationView{
                                DatePicker("Please enter the deadline", selection: self.$due, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .navigationBarTitle("Select a Date")
                                    .navigationBarItems(trailing: Button("Save"){
                                        self.activity.deadline = self.due
                                        self.show = false
                                    })
                            }
                    }
                    
                }
            
            
        }.navigationBarTitle(activity.name)
        .navigationBarItems(trailing: Button("Set Deadline"){
            self.show = true
        })
    }
    func save() -> Void{
        activity.addTime(self.stopWatch.time())
        self.stopWatch.reset()
    }
    func avgtime() -> some View{
        switch activity.formattedTime(){
        case .none: return Text("")
        default: return Text("Avg: \(activity.formattedTime()!)")
        }
    }
    func recentTime() -> some View{
        switch activity.times.count{
        case 0: return Text("")
        default: return Text("Recent: \(activity.formattedRecent())").font(.subheadline)
            .bold()
        }
    }
    
}
extension Array where Element == CGFloat{
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max(){
            return self.map { ($0 - min)/( max - min ) }
        }
        return []
    }
}
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(Activity("Math"))
    }
}
