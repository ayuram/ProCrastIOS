//
//  ProCrastIOSApp.swift
//  ProCrastIOS
//
//  Created by Ayush Raman on 10/17/20.
//

import SwiftUI
import Firebase

@main
struct ProCrastIOSApp: App {
    @State var currentUser: User? = .none
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        Auth.auth().addStateDidChangeListener { _, user in
            currentUser = user
        }
        return WindowGroup {
            switch currentUser {
                case .none: LoginView()
                default: ContentView()
            }
        }
    }
}
