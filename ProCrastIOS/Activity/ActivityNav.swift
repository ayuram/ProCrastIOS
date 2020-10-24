//
//  ActivityNav.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/6/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
extension Int{
    func subtract() -> Int{
        switch self{
        case 1: return 1
        case 0: return 1
        default: return self - 1
        }
    }
}
struct ActivityNav: View {
    let dest: ActivityStats
    @ObservedObject var activity: Activity
    init(_ d: Activity) {
        dest = ActivityStats(d)
        activity = d
    }
    var body: some View {
            NavigationLink(destination: dest) {
                    HStack {
                        VStack{
                        Text(activity.name)
                            //.font(.system(size: 24.0))
                            //.font(.system(.subheadline))
                            .padding(12)
                        //grade()
                        //.font(.system(size: 12.0))
                        
                            
                        }.padding(.leading, 20)
                        Spacer()
                        
                    }.padding(.trailing,100)
                
                
                    .background(activity.color)
                //.clipShape(Capsule())
        }
    }
    
    func text() -> Text{
        Text("\(activity.reps)")
    }
    
}

struct ActivityNav_Previews: PreviewProvider {
    static var previews: some View {
        ActivityNav(Activity("Hello"))
    }
}
