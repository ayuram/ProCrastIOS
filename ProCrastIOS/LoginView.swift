//
//  LoginView.swift
//  ProCrastIOS
//
//  Created by Ayush Raman on 10/24/20.
//

import SwiftUI
import Firebase
struct LoginView: View {
    @State var password: String = "123456"
    @State var username: String = "abc@xyz.com"
    @State var alertMessage = ""
    @State var showAlert = false
    @State var success = false
    var body: some View {
        view()
    }
    func login(){
        Auth.auth().signIn(withEmail: username, password: password){ (result, error) in
            if error != nil {
                alertMessage = error?.localizedDescription ?? ""
                showAlert = true
            }
            else{
                success = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                    username = ""
//                    password = ""
//                }
            }
        }
    }
    func view() -> some View{
        if(!success){
            return AnyView(loginScreen())
        }
        else{
            return AnyView(ContentView())
        }
    }
    func loginScreen() -> some View{
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
                        TextField("Email", text: $username)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                    }
                    Divider()
                    HStack{
                        Image(systemName: "lock.circle.fill")
                        SecureField("Password", text: $password)
                            .disableAutocorrection(true)
                    }
                }
                .padding()
                .frame(width: 300, height: 100, alignment: .center)
                .background(Color("background"))
                .clipShape(Capsule())
                .shadow(color: .green, radius: 10)
                HStack{
                    Spacer()
                    ThemedButton(text: "Register", buttonColor: .orange){
                        
                    }
                    Spacer()
                    ThemedButton(text: "Login", buttonColor: .green){
                        login()
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("Okay")))
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
