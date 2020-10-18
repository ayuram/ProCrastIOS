//
//  ContentView.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/5/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var curr = view.menu
    var activities = Activities()
    var body: some View{
        TabView{
            Config()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Settings")
            }
            ActivityMenu()
                .tabItem{
                    Image(systemName: "list.dash")
                    Text("Activity List")
            }
            Simulation()
                .tabItem{
                    Image(systemName: "paperplane")
                    Text("Dashboard")
            }
        }.environmentObject(activities)
    }
}
enum view{
    case menu
    case simulate
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
