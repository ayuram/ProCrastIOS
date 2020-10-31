//
//  ContentView.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var activities = Data()
    var body: some View{
        TabView{
            Config()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
