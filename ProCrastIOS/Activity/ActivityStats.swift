//
//  ActivityStats.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/13/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct ActivityStats: View {
    @ObservedObject var act: Activity
    init(_ a: Activity){
        act = a
        
    }
    @State var animateChart = false
    var body: some View {
        
        
       
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("background"), Color("background"), act.color.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Text(act.name.capitalized)
                            .bold()
                            .font(.largeTitle)
                            Spacer()
                    }.padding()
                    Spacer()
                    HStack{
                        VStack{
                            
                                
                                BarGraph(name: "Average Time", val: act.avgTime() ?? 0, max: 13, units: "mins").animation(.easeInOut(duration: 1))
                                    .shadow(radius: 10)
                            
                        }.padding()
                        HStack{
                            VStack{
                                Text("20")
                                Spacer()
                                Text("0")
                            }.padding(.vertical, 10)
                            LineGraph(act.times.map{CGFloat($0)})
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
                    
                
            }
            
            
        
        
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
