//
//  DeveloperPreview.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-05.
//

import Foundation
import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockUser = User(
        fullName: "Brandon Oakley",
        email: "test@gmail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude: 46.138927, longitude: -60.193233),
        accountType: .passenger,
        homeLocation: nil,
        workLocation: nil
    )
}
