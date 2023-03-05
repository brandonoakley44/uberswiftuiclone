//
//  SavedLocationRowView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-04.
//

import SwiftUI

struct SavedLocationRowView: View {
    
//    let imageName: String
//    let title: String
//    let subtitle: String // swapping these out with view model instead
    let viewModel: SavedLocationViewModel
//
    var body: some View {
        HStack(spacing: 12) {   // spacing to sepearate stuff in this hStack
            Image(systemName: viewModel.imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(.systemBlue))
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.theme.primaryTextColor)
                
                Text(viewModel.subtitle)
                    .font(.system(size:14))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SavedLocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        // switched to using a view model instead for settings
//        SavedLocationRowView(imageName: "house.circle.fill", title: "Home", subtitle: "Add Home")
        SavedLocationRowView(viewModel: .home)
    }
}
