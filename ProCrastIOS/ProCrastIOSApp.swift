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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            LoginView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        print("Setting Up Firebase")
        FirebaseApp.configure()
        return true
    }
}
