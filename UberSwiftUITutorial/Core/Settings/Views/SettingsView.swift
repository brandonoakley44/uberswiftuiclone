//
//  SettingsView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-04.
//

import SwiftUI

struct SettingsView: View {
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
                                Text("Brandon Oakley")
                                    .font(.system(size:16, weight: .semibold))
                                
                                Text("test@gmail.com")
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
                }
                
                //Note I can make seperate view Models for each of these categories below
                // if i wanted to
                //(Can build an enum!)
                Section("Favorites") {
                  SavedLocationRowView(imageName: "house.circle.fill", title: "Home", subtitle: "Add Home")
                    SavedLocationRowView(imageName: "archivebox.circle.fill", title: "Work", subtitle: "Add Work")
                }
                
                Section("Settings") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "Notifications", tintColor: Color(.systemPurple))
                    
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "Payment Methods", tintColor: Color(.systemBlue))
                }
                
                Section("Account") {
                    SettingsRowView(imageName: "dollarsign.square.fill", title: "Make Money Driving", tintColor: Color(.systemGreen))
                    
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.systemRed))
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        
    }
}
