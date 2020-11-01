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
    @ObservedObject var data: Data = Data()
    @State var color = Color.red
    @State var name: String = ""
    @State var showAlert = false
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .frame(height: 100, alignment: .leading)
                    .foregroundColor(color)
                Text(data.user.name)
                    .fontWeight(.semibold)
                Text(data.user.type.toString())
                    .fontWeight(.ultraLight)
                Spacer()
                Form{
                    Picker(selection: $data.user.type, label: Text("Account Type")){
                        Text("General User").tag(UserType.general)
                        Text("Student").tag(UserType.student)
                        Text("Teacher").tag(UserType.teacher)
                    }
                    NavigationLink(
                        destination: TextField("Enter New Name", text: $data.user.name).disableAutocorrection(true).textFieldStyle(RoundedBorderTextFieldStyle()).card(),
                        label: {
                            VStack{
                                HStack{
                                    Text("Change Name")
                                    Spacer()
                                    Text(data.user.name)
                                        .fontWeight(.ultraLight)
                                }
                                Spacer()
                            }
                        })
                }
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                
                Button("Sign Out"){
                    showAlert = true
                }
                .accentColor(color)
                .card()
                .frame(width: 100, height: 30, alignment: .center)
            }
            .navigationBarTitle("Profile")
            .padding()
        }
    }
}

struct Config_Previews: PreviewProvider {
    static var previews: some View {
        Config()
            //.environmentObject(Data())
    }
}
