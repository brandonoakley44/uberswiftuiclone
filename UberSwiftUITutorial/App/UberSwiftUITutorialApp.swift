//
//  UberSwiftUITutorialApp.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-21.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct UberSwiftUITutorialApp: App {
   // @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // for firebase
    var body: some Scene {
        WindowGroup {
            HomeView()
                //.environmentObject(locationViewModel)
                .environmentObject(authViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
