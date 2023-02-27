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
    @Binding var mapState: MapViewState
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
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id:\.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        //  LocationSearchView(mapState: .constant(.searchingForLocation))
       LocationSearchView(mapState: .constant(.searchingForLocation))
            .environmentObject(LocationSearchViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
