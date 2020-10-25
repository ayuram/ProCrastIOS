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
struct ActivityStats: View {
    @ObservedObject var act: Activity
    init(_ a: Activity){
        act = a
    }
    @State var animateChart = false
    var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("background"), Color("background"), Color("background"), act.color.opacity(1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    HStack{
                        VStack{
                                BarGraph(name: "Average Time", val: act.avgTime() ?? 0, max: 13, units: "mins").animation(.easeInOut(duration: 1))
                                    .shadow(radius: 10)
                            
                        }.padding()
                        HStack{
                            VStack{
                                Text("\(act.times.max()?.int() ?? 0)")
                                Spacer()
                                Text("\(act.times.min()?.int() ?? 0)")
                            }.padding(.vertical, 10)
                            LineGraph(act.times.map{CGFloat($0)}.normalized)
                                .trim(to: animateChart ? 1 : 0)
                                .stroke(act.color, lineWidth: 2)
                                    .onAppear(perform: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                            self.animateChart = true
                                        }
                                    })
                                .animation(.easeInOut(duration: 1))
                                .border(Color.gray, width: 1)
                        }
                    }.frame(height: 200)
                    Spacer()
                    
                }
            }.navigationBarTitle(act.name.capitalized)
    }
    func avgtime() -> some View{
        switch act.formattedTime(){
        case .none: return Text("")
        default: return Text(act.formattedTime()!)
        }
    }
}

struct ActivityStats_Previews: PreviewProvider {
    static var previews: some View {
        ActivityStats(Activity("hello"))
    }
}
