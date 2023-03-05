//
//  SavedLocationSearchView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-04.
//

import SwiftUI

struct SavedLocationSearchView: View {
    
    @State private var text = ""
    
    // not using environment object here (hell explain why in a bit
    @StateObject var viewModel = LocationSearchViewModel()
    
    //Need to know if I am saving as a home location or work location:
    let config: SavedLocationViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .imageScale(.medium)
                    .padding(.leading)
                
                TextField("Search for a location", text: $viewModel.queryFragment)
                    .frame(height: 32)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                    .padding(.trailing)
            }
            
            .padding(.top)
            Spacer()
            
            LocationSearchResultsView(viewModel: viewModel, config: .saveLocation(config))
        }
        .navigationTitle(config.subtitle)
    }
}

struct SavedLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SavedLocationSearchView(config: .home)
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        }
    }
}
