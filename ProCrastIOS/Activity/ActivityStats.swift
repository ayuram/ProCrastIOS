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
    var body: some View {
        
        
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("background"), act.color]), startPoint: .top, endPoint: .bottom)
                
                HStack{
                    VStack{
                        
                        BarGraph(name: "Avg Time", val: 56, max: 13).animation(.easeInOut(duration: 1))
                            .shadow(radius: 10)
                    }.padding()
                    LineGraph(act.times.map{CGFloat($0)})
                    .trim(to: 1)
                    .stroke(Color.red, lineWidth: 2)
                    .aspectRatio(16/9, contentMode: .fit)
                    .border(Color.gray, width: 1)
                    .padding()
                    .animation(.easeInOut(duration: 1))
                }
                    
                .navigationBarTitle(act.name)
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
