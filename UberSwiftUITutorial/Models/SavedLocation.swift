//
//  SavedLocation.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-05.
//

import Foundation
import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint       // for updating coordinates to a database (easier for encoding and decoding)
}
