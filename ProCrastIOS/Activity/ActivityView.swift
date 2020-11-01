//
//  ActivityView.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine
import FirebaseFirestore
import Firebase
import SwiftUICharts
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
    @ObservedObject var activity: Activity
    let myColor: Color
    @ObservedObject var stopWatch = StopWatch()
    @State var on = true
    @State var startIndex = ""
    @State var endIndex = ""
    @State var show = false
    init(_ act: Activity){
        activity = act
        myColor = act.color
    }
    
    var body: some View {
        
                VStack{
                    
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
                            .animation(.default)
                        .minimumScaleFactor(0.1)
                        BarChartView(data: ChartData(values: [("Your Average", activity.avgTime() ?? 0), ("Projected Time", 1), ("Median Time", 17)]), title: "Data")
                    }.padding()
                        .sheet(isPresented: $show){
                            NavigationView{
                                HStack{
                                    TextField("Start Page", text: $startIndex)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(startIndex), perform: { newValue in
                                            let filtered = newValue.filter {"0123456789".contains($0)}
                                            startIndex = filtered != newValue ? filtered : startIndex
                                        })
                                    TextField("End Page", text: $endIndex)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(endIndex), perform: { newValue in
                                            let filtered = newValue.filter {"0123456789".contains($0)}
                                            endIndex = filtered != newValue ? filtered : endIndex
                                        })
                                }
                                .navigationBarTitle("Enter Page Numbers")
                                .navigationBarItems(leading: Button("Cancel"){
                                    show = false
                                    startIndex = ""
                                    endIndex = ""
                                }, trailing: Button("Save"){
//                                    activity.textbook?.pages = (Int(startIndex) ?? 0) ... (Int(endIndex) ?? 0)
//                                    activity.times = []
//
//                                    let db = Firestore.firestore()
//                                    var arr: [Double] = []
//                                    for n in activity.textbook!.pages!{
//                                        print("loading in")
//                                        let docRef = db.collection("\(activity.textbook!.ISBN)").document("\(n)")
//                                        docRef.getDocument { (document, error) in
//                                            if let document = document, document.exists {
//                                                let dataDescription = document.data()?["times"] as? [Double] ?? []
//                                                arr = arr + dataDescription
//                                                print(dataDescription, " and ", arr)
//                                                activity.addTime(arr.mean())
//                                            }
//                                        }
//                                    }
//                                    print("Array", arr)
//                                    activity.times.append(arr.mean())
//                                    //print("Times: ", arr)
//                                    show = false
                                })
                            }
                    }
                    
                }
        .navigationBarTitle(activity.name)
                .navigationBarItems(trailing: Button("Set Pages"){
                    self.show = true
                }.opacity(activity.textbook == .none ? 0 : 1)
                .disabled(activity.textbook == .none))
    }
    func save() -> Void{
        if(activity.reps != 0){
            let val = stopWatch.time()/Double(activity.reps)
            activity.addTime(val)
           // let db = Firestore.firestore()
           
//            if activity.textbook?.pages != .none {
////                db.collection(activity.textbook!.ISBN).document("0").setData(["Timings": 2017, "Type" : "MeMyself"])
//
//                for n in (activity.textbook?.pages)!{
//                    let docRef = Firestore.firestore().document("\(String(describing: activity.textbook!.ISBN))/\(Int(n))")
//                    print("setting data")
//                    docRef.setData(["\(UUID())" : true], merge: true){ error in
//                        if let error = error {
//                            print("error = \(error)")
//                        } else {
//                            print("uploaded")
//                        }
//                    }
//                    docRef.updateData([
//                        "times": FieldValue.arrayUnion([activity.times.last!])
//                    ])
//                }
//            }
        }
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
