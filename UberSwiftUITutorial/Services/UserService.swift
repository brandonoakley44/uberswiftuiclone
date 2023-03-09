//
//  UserService.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-08.
//

import Foundation
import Firebase


struct UserService {
    
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            print("DEBUG;Did fetch user from firestore")
            guard let snapshot = snapshot else { return }
            
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            completion(user)
            print("DEBUG: CURRENT USER IS \(user)")     //14 min mark error eppars
        }

    }
    
}
