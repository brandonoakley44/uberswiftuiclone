//
//  UberLocation.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-27.
//

import Foundation
import CoreLocation

struct UberLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
