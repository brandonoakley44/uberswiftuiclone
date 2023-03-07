//
//  User.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-02.
//

import Foundation
import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let fullName: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType    // var because it can change
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?    //optional because user may or may not have these locations saved
}
