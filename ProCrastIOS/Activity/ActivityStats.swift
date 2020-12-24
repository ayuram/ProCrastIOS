//
//  ActivityStats.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SwiftUICharts
struct ActivityStats: View {
    @ObservedObject var act: Activity
    var chartStyle: ChartStyle
    init(_ a: Activity){
        act = a
        chartStyle = ChartStyle(backgroundColor: .clear, accentColor: Color("accent"), gradientColor: GradientColor(start: a.color, end: a.color), textColor: .gray, legendTextColor: .gray, dropShadowColor: Color("accent"))
    }
    @State var animateChart = false
    var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("background"), Color("background"), Color("background"), act.color.opacity(1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        BarGraph(name: "Average Time", val: act.avgTime() ?? 0, max: 13, units: "mins")
                            .animation(.easeInOut(duration: 1))
                            .shadow(radius: 10)
                            .padding()
                        if(act.times.count > 0){
                            LineView(data: act.times, title: "Your Timeline", style: chartStyle)
                                .frame(height: 400, alignment: .bottom)
                                .background(Color.clear)
                                .padding()
                        }
                    }
                    Spacer()
                    if act.textbook != .none{
                        BarChartView(data: ChartData(values: [("Projected Time", 123), ("Median Time", getAverageTime())]), title: "Pages \(act.textbook?.pages?.first ?? 0) - \(act.textbook?.pages?.last ?? 0)", style: chartStyle, form: ChartForm.extraLarge)
                            .padding()
                    }
                    Spacer()
                }
            }.navigationBarTitle(act.name.capitalized)
    }
    func getAverageTime() -> Double{
        let db = Firestore.firestore()
        var arr: [Double] = []
        for n in act.textbook?.pages ?? 0 ... 0{
            let docRef = db.collection("\(act.textbook!.ISBN)").document("\(n)")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()?["median"] as? Double ?? 0
                    arr.append(dataDescription)
                }
            }
        }
        return arr.mean()
    }
}

struct ActivityStats_Previews: PreviewProvider {
    static var previews: some View {
            ActivityStats(Activity("hello"))
                .preferredColorScheme(.dark)
        
    }
}
