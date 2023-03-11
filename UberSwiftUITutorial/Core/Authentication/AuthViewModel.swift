//
//  AuthViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-28.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    
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
            
            self.fetchUser()    // doing this when signing out and in so app will keep who is actually logged in up to date
        }
    }
    
    
    func registerUser( withEmail email: String, withPassword password: String , fullName: String) {
        
      
        guard let location = LocationManager.shared.userLocation else { return }   //Accessing LocationManager to get user location rather than to hard code it below
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            //If error
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return  // dont want rest of function to run
            }
            
            guard let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser
           // self.userSession = result?.user // sync backend and frontend
            
            let user = User(
                fullName: fullName,
                email: email,
                uid:firebaseUser.uid,
                coordinates:GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .driver
            )
            self.currentUser = user
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
            
            //self.fetchUser()
            
            
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil      // sync backend and front end
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        service.$user
            .sink { user in
                self.currentUser = user
            }
            .store(in: &cancellables)
    }
    
}

