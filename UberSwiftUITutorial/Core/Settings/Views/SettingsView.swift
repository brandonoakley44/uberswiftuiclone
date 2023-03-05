//
//  SettingsView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-04.
//

import SwiftUI

struct SettingsView: View {
    
    private let user: User
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    var body: some View {
        VStack {
            List {
                Section {
                    // User info header
                    HStack {
                        HStack {
                            Image("male-profile-photo")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width:64,height:64)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.fullName)
                                    .font(.system(size:16, weight: .semibold))
                                
                                Text(user.email)
                                    .font(.system(size: 14))
                                    .accentColor(Color.theme.primaryTextColor)
                                    .opacity(0.77)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(8)
                }
                
                //Note I can make seperate view Models for each of these categories below
                // if i wanted to
                //(Can build an enum!)
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(config: viewModel)                        } label: {
                                SavedLocationRowView(viewModel: viewModel, user: user)
                        }
                    }
                }
                
                Section("Settings") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "Notifications", tintColor: Color(.systemPurple))
                    
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "Payment Methods", tintColor: Color(.systemBlue))
                }
                
                Section("Account") {
                    SettingsRowView(imageName: "dollarsign.square.fill", title: "Make Money Driving", tintColor: Color(.systemGreen))
                    
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.systemRed))
                        .onTapGesture {
                            viewModel.signout()
                        }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: User(fullName: "John Doe", email: "johndoe@gmail.com", uid: "123456"))
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        }
        
    }
}
