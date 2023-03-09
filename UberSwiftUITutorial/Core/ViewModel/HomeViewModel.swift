//
//  HomeViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-07.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    
    @Published var drivers = [User]()
    
    
    init() {
        fetchUser()
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return }
                
                let drivers = documents.compactMap({ try?  $0.data(as: User.self) }) // handles non-optional
               self.drivers = drivers //   make it set to the publishable var above so the UberMapView Representable can see them
            }
    }
    
    
    func fetchUser() {
        UserService.fetchUser { user in
            guard user.accountType == .passenger else { return }
            self.fetchDrivers()
        }
        
    }
    
}
