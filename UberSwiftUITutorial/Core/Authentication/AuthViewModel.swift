//
//  AuthViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-28.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    
    init() {
        userSession = Auth.auth().currentUser   //synchronously get cached current user or null if none
    }
    
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: signed user in successfully")
            print("DEBUG: User id \(result?.user.uid)")
            self.userSession = result?.user //sync frontend and backend
        }
    }
    
    
    func registerUser( withEmail email: String, withPassword password: String , fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            //If error
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return  // dont want rest of function to run
            }
            
            print("DEBUG: Registered user successfully")
            print("DEBUG: User id \(result?.user.uid)")
            
            self.userSession = result?.user // sync backend and frontend
            
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did sign out with firebase")
            self.userSession = nil      // sync backend and front end
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
}

