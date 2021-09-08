//
//  ActivityCard.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/24/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct ActivityCard: View {
    @ObservedObject var activity: Activity
    init(_ act: Activity){
        activity = act
    }
    var body: some View {
        NavigationLink(destination: ActivityView(activity)){
            VStack{
                Text(activity.name)
                    .font(.system(.headline))
                    .frame(width: 110)
                HStack{
                    Button(action: {self.activity.changeReps(-)}){
                        Image(systemName: "minus.circle")
                    }
                    .scaleEffect(0.7)
                    
                    Text("\(self.activity.reps)")
                        .scaleEffect(0.9)
                        .frame(width: 30)
                    
                    Button(action: {self.activity.changeReps(+)}){
                        Image(systemName: "plus.circle")
                    }
                    .scaleEffect(0.7)
                }.padding()
                
            }.foregroundColor(Color("text"))
        }
        .frame(width: 130.0, height: 180.0)
            .background(activity.color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(Activity("Math"))
    }
}
