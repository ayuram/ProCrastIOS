//
//  Config.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import Firebase

struct Config: View {
    @EnvironmentObject var data: Data
    @State var color = Color.blue
    @State var userType: User = .student
    var body: some View {
        NavigationView{
            VStack{
                Circle()
                    .frame(height: 100, alignment: .leading)
                    .foregroundColor(color)
                Text("Ayush Raman")
                    .fontWeight(.semibold)
                Text("Student")
                    .fontWeight(.ultraLight)
                Spacer()
                Form{
                    Picker(selection: $userType, label: Text("Account Type")){
                        Text("General").tag(User.general)
                        Text("Student").tag(User.student)
                        Text("Teacher").tag(User.teacher)
                    }
                }
                CardView(){
                    Text("Sign Out")
                    .foregroundColor(.red)
                    .format()
                }.frame(width: 100, height: 30, alignment: .center)
                .onTapGesture(count: 1, perform: {
                    color = .red
                })
                .onLongPressGesture {
                    color = .green
                }
                
            }
            .navigationBarItems(trailing: Button("Save"){
                
            })
            .navigationBarTitle("Profile")
            .padding()
        }
    }
    func actions(){
        
    }
}

struct Config_Previews: PreviewProvider {
    static var previews: some View {
        Config()
            .environmentObject(Data())
    }
}
