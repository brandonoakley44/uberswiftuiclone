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
    
    
    let mockTrip = Trip(
        id: NSUUID().uuidString,
        passengerUid: NSUUID().uuidString,
        driverUid: NSUUID().uuidString,
        passengerName: "Stephan Dowless",
        driverName: "Jane Done",
        passengerLocation: .init(latitude: 46.129997, longitude: -60.22),
        driverLocation: .init(latitude: 46.129997, longitude: -60.22),
        pickupLocationName: "Apple Campus Sydney",
        dropoffLocationName: "CBU",
        pickupLocationAddress: "123 Grand Lake Road",
        pickupLocation: .init(latitude: 46.130997, longitude: -60.24),
        dropoffLocation: .init(latitude: 46.139997, longitude: -60.24),
        tripCost: 47.0,
        distanceToPassenger: 1000,
        travelTimeToPassenger: 24
        )
    
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
