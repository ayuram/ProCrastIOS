//
//  LoginView.swift
//  ProCrastIOS
//
//  Created by Ayush Raman on 10/24/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State var password: String = ""
    @State var email: String = ""
    @State var confirmPass: String = ""
    @State var alertMessage = ""
    @State var showAlert = false
    @State var success = false
    @State var sht = false
    var body: some View {
        view()
            //.animation(.linear)
            .sheet(isPresented: $sht){
                registerField()
            }
        
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if error != nil {
                alertMessage = error?.localizedDescription ?? ""
                showAlert = true
            }
            else{
                success = true
                email = ""
                password = ""
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                    username = ""
//                    password = ""
//                }
            }
        }
    }
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
            if error != nil {
                alertMessage = error?.localizedDescription ?? ""
                password = ""
                confirmPass = ""
                showAlert = true
            }
            else{
                password = ""
                confirmPass = ""
                sht = false
            }
        }
    }
    func registerField() -> some View{
        NavigationView{
            VStack{
                HStack{
                    Image(systemName: "person.circle.fill")
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                }
                Divider()
                HStack{
                    Image(systemName: "lock.circle")
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Divider()
                HStack{
                    Image(systemName: "lock.circle.fill")
                    SecureField("Password", text: $confirmPass)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationBarTitle("Register Account")
            .navigationBarItems(leading: Button("Cancel"){
                password = ""
                confirmPass = ""
                email = ""
                sht = false
            }, trailing: Button("Save"){
                register()
            })
        }
    }
    func view() -> some View{
        if(!success){
            return AnyView(loginScreen()
                            .transition(.scale))
        }
        else{
            return AnyView(ContentView().transition(.scale))
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
                    .frame(width: 380, height: 280, alignment: .top)
                    .clipped()
                    
                Spacer()
                VStack{
                    HStack{
                        Image(systemName: "person.circle.fill")
                        TextField("Email", text: $email)
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
                .shadow(color: success ? .green : .red, radius: success ? 3 : 10)
                .animation(.default)
                    ThemedButton("Login", buttonColor: .green){
                        login()
                    }
                
                    GSignIn()
                        .frame(width: 300, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                    ThemedButton("Register", buttonColor: .orange){
                        sht.toggle()
                    }
                
            }
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("Confirm")))
        })
    }
}
struct GSignIn: UIViewRepresentable{
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .standard
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
    }
}
