//
//  LocationSearchView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var startLocationText = ""
    //@Binding var showLocationSearchView: Bool
   // @Binding var mapState: MapViewState //map state no longer tied to locationsearchview so I can remove it
    //@StateObject var viewModel = LocationSearchViewModel()
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    
    
    
    var body: some View {
        VStack {
            // Header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                //Text fields
                VStack {
                    TextField("Current Location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            
            //List View
            LocationSearchResultsView(viewModel: viewModel, config: .ride) // I know its ride because I am in LocationSearchView
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        //  LocationSearchView(mapState: .constant(.searchingForLocation))
       LocationSearchView()
            .environmentObject(LocationSearchViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}

