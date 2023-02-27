//
//  UberSwiftUITutorialApp.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-21.
//

import SwiftUI

@main
struct UberSwiftUITutorialApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
