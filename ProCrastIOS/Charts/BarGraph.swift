//
//  BarGraph.swift
//  FTCscorer
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 MSET Cuttlefish. All rights reserved.
//

import SwiftUI

struct BarGraph: View {
    var width: CGFloat = 30
    var height: CGFloat = 100
    var name: String
    var val: Double
    var max: Double
    var units: String = ""
    var flip: Bool = false
    @State var sheet = false
    
    var body: some View {
        choice()
    }
    func choice() -> some View{
        (max >= 1 || !flip) ? AnyView(normal()) : AnyView(abnormal())
    }
    func normal() -> some View{
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.black)
                        .border(Color("text"))
                    Capsule().frame(width: width, height: height * CGFloat((val)/max))
                        .foregroundColor(color())
                }
                (flip ? Text("\(Int(max)) \(units)") : Text("\(Int(val)) \(units)"))
                    .font(.caption)
            }
        
    }
    func abnormal() -> some View{
        
            VStack{
                Text(name)
                    .font(.caption)
                ZStack(alignment: .bottom){
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.black)
                        .border(Color("text"))
                    Capsule().frame(width: width, height: height)
                        .foregroundColor(.green)
                }
                Text("\(Int(max)) \(units)")
                    .font(.caption)
            }
       
    }
    func color() -> Color{
        if(val/max < 0.25){
            return .green
        }
        else if (val/max < 0.75){
            return .yellow
        }
        else{
            return .red
        }
    }
    
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(name: "OK", val: 1, max: 13, flip: true)
    }
}

