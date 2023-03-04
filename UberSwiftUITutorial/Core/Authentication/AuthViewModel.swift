//
//  AuthViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-28.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    
    init() {
        userSession = Auth.auth().currentUser   //synchronously get cached current user or null if none
        fetchUser()
    }
    
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
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
            
            guard let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser
           // self.userSession = result?.user // sync backend and frontend
            
            let user = User(fullName: fullName, email: email, uid: firebaseUser.uid)
            
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
            
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
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }    //can alsuo user user session at top
        //
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            self.currentUser = user
        }
    }
    
}

