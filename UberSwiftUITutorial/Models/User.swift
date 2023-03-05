//
//  User.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-02.
//

import Foundation

struct User: Codable {
    let fullName: String
    let email: String
    let uid: String
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?    //optional because user may or may not have these locations saved
}
