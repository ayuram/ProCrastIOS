//
//  ActivityMenu.swift
//  ProCrast
//
//  Created by Ayush Raman on 8/7/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct ActivityMenu: View {
    @State public var show = false
    @EnvironmentObject var activities: Activities
    @State var actname: String = ""
    var body: some View {
        ZStack{
            NavigationView {
                List{
                    ForEach(activities.activities) { activity in
                        ActivityNav(activity)
                    }.onDelete(perform: deleteItems)
                }
                .navigationBarTitle("Activities")
                .navigationBarItems(trailing: Button(action: {
                    self.show = true
                }){
                    Image(systemName: "plus.circle.fill")
                    }
                
                .contentShape(Circle())
                )
                
               
                .accentColor(Color("accent"))
            }
        
            .blur(radius: show ? 4 : 0)
            if(show){
                self.newAct()
            }
        }
    }
    func deleteItems(at offsets: IndexSet){
        activities.activities.remove(atOffsets: offsets)
    }
    func newAct() -> some View{
        ZStack{
            VStack {
                //Text("Activity Name")
                
                TextField("Name", text: $actname)
                    .padding()
                    .zIndex(1)
                Divider()
                HStack{
                    Button("Cancel"){
                        self.show = false
                        self.actname = ""
                    }.frame(width: 60, alignment: Alignment.leading)
                        
                    Divider()
                    Button("Save"){
                        self.activities.activities.append(Activity(self.actname))
                        self.actname = ""
                        self.show = false
                    }.frame(width: 60, alignment: Alignment.trailing)
                }
            }
            .background(Color.white)
            .frame(width: 200.0, height: 150.0)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 3.0))
            .compositingGroup()
            .shadow(radius: 1)
            .cornerRadius(2)
        }
    }
}

struct ActivityMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActivityMenu()
    }
}
