//
//  LoginView.swift
//  ProCrastIOS
//
//  Created by Ayush Raman on 10/24/20.
//

import SwiftUI

struct LoginView: View {
    @State var password: String = ""
    @State var username: String = ""
    var body: some View {
        ZStack{
            Color("accent")
                .ignoresSafeArea()
            
            VStack{
                Image("loadingscreen-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 380, height: 380, alignment: .bottom)
                    .clipped()
                    
                Spacer()
                VStack{
                    HStack{
                        Image(systemName: "person.circle.fill")
                        TextField("Username", text: $username)
                    }
                    Divider()
                    HStack{
                        Image(systemName: "lock.circle.fill")
                        SecureField("Password", text: $password)
                    }
                }
                .padding()
                .frame(width: 300, height: 100, alignment: .center)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
                HStack{
                    Spacer()
                    ThemedButton(text: "Register", buttonColor: .orange){
                        
                    }
                    Spacer()
                    ThemedButton(text: "Login", buttonColor: .green){
                        
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
